import assert from 'node:assert/strict';
import { test } from 'node:test';
import * as plugin from '../config/opencode/plugin/agents-system-guard.js';

test('every auto-loaded export is a plugin factory returning hooks', async () => {
  for (const [name, factory] of Object.entries(plugin)) {
    assert.equal(typeof factory, 'function', name);
    const hooks = await factory({});
    assert.ok(hooks && typeof hooks === 'object', `${name} must return hooks, not null`);
  }
});
