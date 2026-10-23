const { strict: assert } = require('node:assert');
const { clamp } = require('./clamp.cjs');
assert.equal(clamp(5, 0, 10), 5);
assert.equal(clamp(-2, 0, 10), 0);
assert.equal(clamp(15, 0, 10), 10);
assert.equal(clamp(0, 0, 10), 0);
assert.equal(clamp(10, 0, 10), 10);
assert.equal(clamp(-3, -5, -1), -3);
console.log('CLAMP_CHECKS_OK');
