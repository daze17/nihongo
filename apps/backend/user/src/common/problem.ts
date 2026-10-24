import { STATUS_CODES } from 'node:http';

/** RFC 9457 problem details. Every error the API returns has this shape. */
export interface Problem {
  type: string;
  title: string;
  status: number;
  detail: string;
  instance: string;
  /** oRPC error code, e.g. NOT_FOUND, BAD_REQUEST. */
  code?: string;
  /** Field-level validation errors. */
  errors?: { path: string; message: string }[];
}

export const PROBLEM_CONTENT_TYPE = 'application/problem+json';

export function problem(input: {
  status: number;
  detail?: string;
  instance: string;
  code?: string;
  errors?: Problem['errors'];
}): Problem {
  const { status, instance, code, errors } = input;
  return {
    type: 'about:blank',
    title: STATUS_CODES[status] ?? 'Error',
    status,
    // Never leak internals on 5xx.
    detail: status >= 500 ? 'Something went wrong on our side.' : (input.detail ?? ''),
    instance,
    ...(code ? { code } : {}),
    ...(errors?.length ? { errors } : {}),
  };
}

interface OrpcErrorBody {
  defined: boolean;
  code: string;
  status: number;
  message: string;
  data?: unknown;
}

export function isOrpcErrorBody(body: unknown): body is OrpcErrorBody {
  return (
    typeof body === 'object' &&
    body !== null &&
    typeof (body as OrpcErrorBody).code === 'string' &&
    typeof (body as OrpcErrorBody).status === 'number' &&
    'defined' in body
  );
}

/** Converts oRPC's error JSON (`{ defined, code, status, message, data }`) to problem+json. */
export function problemFromOrpc(body: OrpcErrorBody, instance: string): Problem {
  return problem({
    status: body.status,
    detail: body.message,
    instance,
    code: body.code,
    errors: validationIssues(body.data),
  });
}

function validationIssues(data: unknown): Problem['errors'] {
  const issues = (data as { issues?: unknown } | undefined)?.issues;
  if (!Array.isArray(issues)) return undefined;
  return issues.map((issue: { message?: string; path?: unknown[] }) => ({
    path: (issue.path ?? [])
      .map((p) => (typeof p === 'object' && p !== null && 'key' in p ? String(p.key) : String(p)))
      .join('.'),
    message: issue.message ?? 'Invalid value',
  }));
}
