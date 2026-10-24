import { describe, expect, it } from 'vitest';
import { isOrpcErrorBody, problem, problemFromOrpc } from './problem.js';

describe('problem', () => {
  it('uses the HTTP reason phrase as title', () => {
    expect(problem({ status: 404, detail: 'nope', instance: '/x' })).toMatchObject({
      title: 'Not Found',
      status: 404,
      detail: 'nope',
    });
  });

  it('hides details on 5xx', () => {
    expect(problem({ status: 500, detail: 'db password wrong', instance: '/x' }).detail).toBe(
      'Something went wrong on our side.',
    );
  });
});

describe('problemFromOrpc', () => {
  it('maps oRPC validation issues to field errors', () => {
    const body = {
      defined: false,
      code: 'BAD_REQUEST',
      status: 400,
      message: 'Input validation failed',
      data: { issues: [{ message: 'Required', path: ['changes', { key: 'items' }, 0] }] },
    };
    expect(isOrpcErrorBody(body)).toBe(true);
    expect(problemFromOrpc(body, '/v1/sync')).toEqual({
      type: 'about:blank',
      title: 'Bad Request',
      status: 400,
      detail: 'Input validation failed',
      instance: '/v1/sync',
      code: 'BAD_REQUEST',
      errors: [{ path: 'changes.items.0', message: 'Required' }],
    });
  });

  it('does not treat ordinary JSON as an oRPC error', () => {
    expect(isOrpcErrorBody({ status: 'ok' })).toBe(false);
  });
});
