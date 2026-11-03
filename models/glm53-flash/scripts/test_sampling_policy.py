"""Regression checks for uniform sample exclusion and pooled throughput."""
import unittest

from sampling_policy import BATCHES, INCLUDED_STEPS, rate, retained, selection


class SamplingPolicyTest(unittest.TestCase):
    def points(self):
        return [dict(batch_size=bs, group=f'g{g}', step=step,
                     split='train' if g < 3 else 'validation' if g < 5 else 'test',
                     milliseconds=.01 if step == 1 else float(bs))
                for bs in BATCHES for g in range(7) for step in (1,) + INCLUDED_STEPS]

    def test_exclusion_applies_to_every_batch_group_and_split(self):
        original = self.points()
        selected = retained(original)
        self.assertEqual(len(original), 840)
        self.assertEqual(len(selected), 735)
        self.assertEqual({r['step'] for r in selected}, set(INCLUDED_STEPS))
        self.assertEqual(rate([r for r in selected if r['batch_size'] == 128], 128), 250)
        self.assertEqual(selection(selected)['selected_batch_size'], 16)

    def test_already_filtered_input_is_idempotent(self):
        selected = retained(self.points())
        self.assertEqual(retained(selected), selected)

    def test_missing_or_duplicate_retained_points_fail(self):
        selected = retained(self.points())
        with self.assertRaisesRegex(AssertionError, 'Incomplete'):
            retained(selected[:-1])
        with self.assertRaisesRegex(AssertionError, 'Duplicate'):
            retained(selected + selected[:1])

    def test_rate_uses_total_time_not_mean_throughput(self):
        self.assertEqual(rate([dict(milliseconds=1), dict(milliseconds=3)], 4), 500)


if __name__ == '__main__':
    unittest.main()
