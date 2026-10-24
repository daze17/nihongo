import { Logger } from '@nestjs/common';
import { ORPCError, ORPCModule, onError } from '@orpc/nest';
import type { Request, Response } from 'express';
import { PROBLEM_CONTENT_TYPE, isOrpcErrorBody, problemFromOrpc } from '../common/problem.js';

const logger = new Logger('oRPC');

/**
 * oRPC runs inside Nest controllers (see `@Implement`). Nest's JSON body parser stays on,
 * so its 100 kb limit applies to oRPC bodies too.
 */
export const OrpcModule = ORPCModule.forRoot({
  interceptors: [
    onError((error) => {
      // Expected errors (NOT_FOUND, BAD_REQUEST, ...) are part of the contract; only log real failures.
      if (!(error instanceof ORPCError) || error.status >= 500) logger.error(error);
    }),
  ],
  sendResponseInterceptors: [
    async ({ request, response, standardResponse, next }) => {
      const body = standardResponse.body;
      if (standardResponse.status < 400 || !isOrpcErrorBody(body)) return next();
      const req = request as Request;
      const res = response as Response;
      const p = problemFromOrpc(body, req.originalUrl);
      res.status(p.status).type(PROBLEM_CONTENT_TYPE).send(JSON.stringify(p));
    },
  ],
});
