"""Guard against reporting independently maximized stages as full MoE latency."""
import unittest

from import_results import analytic_exception, layer_cycles


class CriticalPathTest(unittest.TestCase):
    def test_absent_shared_on_non_owner_is_not_a_numerical_failure(self):
        self.assertFalse(analytic_exception(dict(analytic_synthetic_budget_pass=True, shared_analytic_error=None)))
        self.assertTrue(analytic_exception(dict(analytic_synthetic_budget_pass=False, shared_analytic_error=None)))
        self.assertTrue(analytic_exception(dict(analytic_synthetic_budget_pass=True, shared_analytic_error=dict(passed=False))))

    def test_different_stage_bottlenecks_do_not_form_a_fictitious_rank(self):
        rows = [dict(cycles=100, stages=dict(router=90, routed=10)),
                dict(cycles=100, stages=dict(router=10, routed=90))]
        total, stages = layer_cycles(rows)
        self.assertEqual(total, 100)
        self.assertEqual(sum(stages.values()), 180)

    def test_shared_only_owner_can_determine_the_critical_rank(self):
        rows = [dict(cycles=120, stages=dict(router=10, routed=10, shared=90, reduce=10)),
                dict(cycles=110, stages=dict(router=10, routed=90, reduce=10))]
        total, stages = layer_cycles(rows)
        self.assertEqual(total, 120)
        self.assertEqual(stages['shared'], 90)
        self.assertEqual(stages['routed'], 90)


if __name__ == '__main__':
    unittest.main()
