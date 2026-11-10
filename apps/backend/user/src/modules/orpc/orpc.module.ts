import { Logger } from "@nestjs/common";
import { onError, ORPCError, ORPCModule } from "@orpc/nest";
import type { FastifyReply, FastifyRequest } from "fastify";

import {
  isOrpcErrorBody,
  PROBLEM_CONTENT_TYPE,
  problemFromOrpc,
} from "@/common/utils/problem";

const logger = new Logger("oRPC");

/** oRPC runs inside Nest controllers (see `@Implement`). Errors leave as problem+json. */
export const OrpcModule = ORPCModule.forRoot({
  interceptors: [
    onError((error) => {
      // Expected errors (NOT_FOUND, BAD_REQUEST, ...) are part of the contract; only log real failures.
      if (!(error instanceof ORPCError) || error.status >= 500) {
        logger.error(error);
      }
    }),
  ],
  sendResponseInterceptors: [
    async ({ request, response, standardResponse, next }) => {
      const body = standardResponse.body;
      if (standardResponse.status < 400 || !isOrpcErrorBody(body)) {
        return next();
      }
      const problem = problemFromOrpc(body, (request as FastifyRequest).url);
      await (response as FastifyReply)
        .status(problem.status)
        .header("content-type", PROBLEM_CONTENT_TYPE)
        .send(JSON.stringify(problem));
    },
  ],
});
