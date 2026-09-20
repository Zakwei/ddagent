import assert from 'node:assert/strict';
import test from 'node:test';

import { isHttpUrl, normalizeInput } from './browserUrl';

test('isHttpUrl accepts only http(s) urls', () => {
  assert.equal(isHttpUrl('https://example.com'), true);
  assert.equal(isHttpUrl('http://localhost:3000/path'), true);
  assert.equal(isHttpUrl('HTTPS://EXAMPLE.COM'), true);
  assert.equal(isHttpUrl('javascript:alert(1)'), false);
  assert.equal(isHttpUrl('file:///etc/hosts'), false);
  assert.equal(isHttpUrl('example.com'), false);
  assert.equal(isHttpUrl(''), false);
  assert.equal(isHttpUrl(undefined), false);
  assert.equal(isHttpUrl(null), false);
});

test('normalizeInput keeps full http(s) urls and trims whitespace', () => {
  assert.equal(normalizeInput('https://example.com/path'), 'https://example.com/path');
  assert.equal(normalizeInput('  http://localhost:3000  '), 'http://localhost:3000');
  assert.equal(normalizeInput('HTTPS://EXAMPLE.COM'), 'HTTPS://EXAMPLE.COM');
});

test('normalizeInput upgrades bare hostnames to https', () => {
  assert.equal(normalizeInput('example.com'), 'https://example.com');
  assert.equal(normalizeInput('www.example.com/path?q=1#frag'), 'https://www.example.com/path?q=1#frag');
  assert.equal(normalizeInput('sub.example.co.uk'), 'https://sub.example.co.uk');
});

test('normalizeInput rejects empty and non-url input', () => {
  assert.equal(normalizeInput(''), null);
  assert.equal(normalizeInput('   '), null);
  assert.equal(normalizeInput('hello world'), null);
  assert.equal(normalizeInput('javascript:alert(1)'), null);
  assert.equal(normalizeInput('not-a-domain'), null);
  assert.equal(normalizeInput('localhost:5173'), null);
});
