# Bounded worker evaluation fixtures

These deliberately broken snippets are inert benchmark inputs, not production
helpers and not part of the passing runtime suite. Copy them to a temporary
workspace before a live run. Never edit these originals to make CI green.

Define acceptance before execution, then use the existing delegation bridge:

1. Source lookup (read): fetch `https://nodejs.org/api/assert.html`, explain
   `strictEqual` versus `deepStrictEqual`, and cite the official source. Parent
   checks that `strictEqual(1, '1')` throws and deep equality compares structure.
2. Scoped edit: modify **only** the copied `clamp.cjs` for finite numeric inputs
   with min <= max. Parent runs `node clamp.test.cjs` and verifies file scope.
3. Review (read): identify the authorization defect in `review.cjs`, with a line
   reference and a reproduction using a synthetic viewer. Parent checks mutation
   and the erroneous true result. No editing is authorized for this task.

One candidate/run per task, existing timeout/attempt limits, verified-free models
only. Record correctness, scope, provider/model, reported usage/cost, elapsed time
and primary preparation/review separately. Missing measurements stay unknown.
One run is a smoke sample, not a reliable model ranking or savings benchmark.
