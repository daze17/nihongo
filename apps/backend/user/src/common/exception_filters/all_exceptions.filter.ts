import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpStatus,
} from "@nestjs/common";
import type { FastifyReply, FastifyRequest } from "fastify";
import { Logger } from "nestjs-pino";

import { PROBLEM_CONTENT_TYPE, problem } from "@/common/utils/problem";

/** Anything that is not an HttpException is a bug: log it, answer a 500 problem. */
@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  constructor(private readonly logger: Logger) {}

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<FastifyRequest>();
    const response = ctx.getResponse<FastifyReply>();

    this.logger.error(
      { path: request.url, method: request.method, err: exception },
      "AllExceptionsFilter",
    );

    const status = HttpStatus.INTERNAL_SERVER_ERROR;
    response
      .status(status)
      .header("content-type", PROBLEM_CONTENT_TYPE)
      .send(JSON.stringify(problem({ status, instance: request.url })));
  }
}
