import assert from 'node:assert/strict';
import { test } from 'node:test';
import { mkdtempSync, mkdirSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { spawnSync } from 'node:child_process';

const pluginUrl = new URL('../config/opencode/plugin/agents-system-guard.js', import.meta.url).href;
const validRules = JSON.parse(readFileSync(new URL('../.agents/hooks/guard-rules.json', import.meta.url), 'utf8'));
const childScript = `
  import { readFileSync } from 'node:fs';
  import * as plugin from ${JSON.stringify(pluginUrl)};
  const actions = JSON.parse(readFileSync(0, 'utf8'));
  const results = [];
  for (const [name, factory] of Object.entries(plugin)) {
    if (typeof factory !== 'function') throw new Error(name + ' must be a factory');
    const hooks = await factory({});
    if (!hooks || typeof hooks['tool.execute.before'] !== 'function') {
      throw new Error(name + ' must return tool hooks');
    }
    const outcomes = [];
    for (const action of actions) {
      try {
        await hooks['tool.execute.before']({ tool: action.tool }, { args: action.args });
        outcomes.push(null);
      } catch (error) {
        outcomes.push(error.message);
      }
    }
    results.push({ name, outcomes });
  }
  process.stdout.write(JSON.stringify(results));
`;

function runGuard(rawRules, actions) {
  const fixtureHome = mkdtempSync(join(tmpdir(), 'opencode-guard-'));
  try {
    const hooksDir = join(fixtureHome, '.agents', 'hooks');
    mkdirSync(hooksDir, { recursive: true });
    if (rawRules !== undefined) writeFileSync(join(hooksDir, 'guard-rules.json'), rawRules);
    const child = spawnSync(process.execPath, ['--input-type=module', '--eval', childScript], {
      env: { ...process.env, HOME: fixtureHome, USERPROFILE: fixtureHome },
      input: JSON.stringify(actions), encoding: 'utf8', timeout: 10000,
    });
    assert.equal(child.error, undefined);
    assert.equal(child.status, 0, child.stderr);
    const results = JSON.parse(child.stdout);
    assert.ok(results.length > 0, 'plugin must export a factory');
    return results;
  } finally {
    rmSync(fixtureHome, { recursive: true, force: true });
  }
}

test('every auto-loaded export is a plugin factory returning hooks', async () => {
  runGuard(JSON.stringify(validRules), []);
});

const protectedActions = [
  { tool: 'bash', args: { command: 'git status' } },
  { tool: 'bash', args: { command: 'git push --force' } },
  { tool: 'read', args: { filePath: 'README.md' } },
  { tool: 'read', args: { filePath: '.env' } },
  { tool: 'bash' },
  { tool: 'read' },
];

const invalidRules = [
  ['missing file', undefined],
  ['corrupt JSON', '{"private-canary": secret-canary-value'],
  ...[
    ['null document', null], ['array document', []], ['string document', 'secret-canary-value'],
    ['missing fields', {}], ['missing bash', { readPath: validRules.readPath }],
    ['non-array bash', { ...validRules, bash: {} }], ['empty bash', { ...validRules, bash: [] }],
    ['missing readPath', { bash: validRules.bash }],
    ['array readPath', { ...validRules, readPath: [] }],
    ...['bash', 'readPath'].flatMap(section => [
      ['null rule', null], ['string rule', 'secret-canary-value'],
      ['missing pattern', { reason: 'blocked' }],
      ['numeric pattern', { pattern: 42, reason: 'blocked' }],
      ['empty pattern', { pattern: ' ', reason: 'blocked' }],
      ['invalid regex', { pattern: '[secret-canary-value', reason: 'blocked' }],
      ['missing reason', { pattern: 'danger' }],
      ['numeric reason', { pattern: 'danger', reason: 42 }],
      ['empty reason', { pattern: 'danger', reason: ' ' }],
    ].map(([name, rule]) => [
      `${section}: ${name}`,
      { ...validRules, [section]: section === 'bash' ? [...validRules.bash, rule] : rule },
    ])),
  ].map(([name, rules]) => [name, JSON.stringify(rules)]),
];

for (const [name, rawRules] of invalidRules) {
  test(`invalid rules fail closed: ${name}`, () => {
    for (const { outcomes } of runGuard(rawRules, [...protectedActions, { tool: 'glob', args: {} }])) {
      for (const message of outcomes.slice(0, protectedActions.length)) {
        assert.equal(typeof message, 'string', 'protected action must be blocked');
        assert.match(message, /guard-rules\.json/);
        assert.match(message, /restore|repair|fix/i);
        assert.doesNotMatch(message, /secret-canary-value|private-canary/);
      }
      assert.equal(outcomes.at(-1), null, 'unprotected tool stays available for recovery');
    }
  });
}

test('valid rules allow safe actions and block dangerous actions', () => {
  const actions = [
    ...['git status', 'git push origin feature', 'cat .env.example'].map(command => ({ tool: 'bash', args: { command } })),
    ...['README.md', '.env.example', '.env.sample', '.env.template'].map(filePath => ({ tool: 'read', args: { filePath } })),
    ...['git push --force', 'git push --force-with-lease', 'git push origin +HEAD:main', 'rm -rf /', 'cat .env', 'GET-CONTENT .env.production'].map(command => ({ tool: 'bash', args: { command } })),
    { tool: 'read', args: { filePath: 'C:\\project\\.ENV' } },
    { tool: 'read', args: { file_path: '/project/.env.production' } },
  ];
  for (const { outcomes } of runGuard(JSON.stringify(validRules), actions)) {
    assert.deepEqual(outcomes.slice(0, 7), Array(7).fill(null));
    for (const message of outcomes.slice(7)) assert.match(message, /^Bloqueado: /);
  }
});
