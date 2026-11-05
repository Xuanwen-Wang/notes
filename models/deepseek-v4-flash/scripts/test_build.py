"""Exercise measurement boundaries that could otherwise produce false totals."""
from copy import deepcopy
import unittest
import build


def fixture():
    cases = []
    for batch in build.BATCHES:
        for layer in range(build.LAYERS):
            for rank in range(build.RANKS):
                values = dict(router=2, shared=3, routed=4, reduce=5)
                if layer == 0 and rank == 0:
                    values['router'] = 100
                if layer == 0 and rank == 1:
                    values['routed'] = 100
                stages = {stage: dict(cycles=value, launches=[dict(kernel=build.BUSINESS_KERNELS[stage],
                    launch=index + 2, core_cycles=[value - 1, value], cycles=value)])
                    for index, (stage, value) in enumerate(values.items())}
                cases.append(dict(bs=batch, layer=layer, rank=rank, stages=stages,
                    cycles=sum(values.values()), evidence=dict(router_fp64_pass=True, ffn_numerical_pass=False)))
    summary, _ = build.aggregate(cases)
    return dict(schema_version=2, kind='dsv4-moe-real-capture', status='preview', clock_hz=build.CLOCK_HZ,
        scope=dict(batches=list(build.BATCHES), layers=build.LAYERS, ranks=build.RANKS, decode_step=17,
            history=4096, boundary='compute_only', hidden=4096, intermediate_per_tp=512, routed_experts=256,
            topk=6, zeus_tp=4, zeus_ep=4, h200_tp=1, h200_ep=4),
        tools=dict(compiler_sha256='a' * 64), sources=dict(matrix='b' * 64),
        implementation=dict(product_manifest={'example.py': 'c' * 64}),
        denominators={key: dict(totals_ms=dict(value)) for key, value in build.FROZEN_DENOMINATORS.items()},
        cases=cases, summary=summary,
        qualification=dict(reference_sha256='d' * 64,
            cpu=dict(initial_cases=129, additional_critical_cases=0, unique_cases=129, graph_replays=258),
            critical=dict(cases=129, graph_replays=258, pointwise_failures=0,
                max_relative_l2=dict(routed=0., shared=0., shared_no_activation_qdq=0.)),
            mode=dict(full_cases=6, timing_cases=6, graph_replays=12),
            matrix=dict(timing_cases=2064, router_fp64_cases=2064, native_completion_passed=True,
                ffn_numerical_pass=False)))


BASE = fixture()


class MeasurementBoundariesTest(unittest.TestCase):
    def setUp(self):
        self.data = deepcopy(BASE)

    def test_selects_complete_rank_before_stage_decomposition(self):
        summaries, selected = build.validate_current(self.data, preview=True)
        self.assertEqual(selected[0]['rank'], 0)
        self.assertEqual(selected[0]['cycles'], 112)
        self.assertEqual(summaries[0]['cycles'], 112 + 42 * 14)
        self.assertNotEqual(summaries[0]['cycles'], 208 + 42 * 14)

    def test_rejects_stage_maxima_from_different_ranks(self):
        self.data['summary'][0]['stage_cycles']['routed'] += 96
        with self.assertRaisesRegex(ValueError, 'one complete rank'):
            build.validate_current(self.data, preview=True)

    def test_rejects_duplicate_missing_coordinate(self):
        self.data['cases'][-1] = self.data['cases'][0]
        with self.assertRaisesRegex(ValueError, 'Duplicate or missing'):
            build.validate_current(self.data, preview=True)

    def test_rejects_core_duration_in_place_of_max(self):
        self.data['cases'][0]['stages']['router']['launches'][0]['cycles'] -= 1
        with self.assertRaisesRegex(ValueError, 'max\\(core0, core1\\)'):
            build.validate_current(self.data, preview=True)

    def test_rejects_outside_fill_inserted_into_window(self):
        item = self.data['cases'][0]['stages']['router']
        item['launches'].append(dict(kernel='fill_bf16', launch=1, core_cycles=[10, 10], cycles=10))
        item['cycles'] += 10
        with self.assertRaisesRegex(ValueError, 'four business'):
            build.validate_current(self.data, preview=True)

    def test_lowest_rank_breaks_ties(self):
        row = self.data['cases'][1]
        row['stages']['routed']['cycles'] += 2
        row['cycles'] += 2
        _, selected = build.aggregate(self.data['cases'])
        self.assertEqual(selected[0]['rank'], 0)

    def test_preview_requires_explicit_flag(self):
        with self.assertRaisesRegex(ValueError, 'requires --preview'):
            build.validate_current(self.data)

    def test_template_cannot_become_measured_final(self):
        self.data.update(status='final', template_only=True)
        with self.assertRaisesRegex(ValueError, 'template is not measured'):
            build.validate_current(self.data)

    def test_rejects_timing_as_ffn_numerical_pass(self):
        self.data['qualification']['matrix']['ffn_numerical_pass'] = True
        with self.assertRaisesRegex(ValueError, 'Matrix evidence'):
            build.validate_current(self.data, preview=True)

    def test_rejects_machine_path(self):
        self.data['private_origin'] = '/mnt/private/case.json'
        with self.assertRaisesRegex(ValueError, 'machine path'):
            build.validate_current(self.data, preview=True)

    def test_frozen_denominator_cannot_roll(self):
        self.data['denominators']['master']['totals_ms']['16'] += 1
        with self.assertRaisesRegex(ValueError, 'Frozen denominator'):
            build.validate_current(self.data, preview=True)


if __name__ == '__main__':
    unittest.main()
