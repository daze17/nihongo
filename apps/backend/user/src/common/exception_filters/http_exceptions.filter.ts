import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
} from "@nestjs/common";
import type { FastifyReply, FastifyRequest } from "fastify";
import { Logger } from "nestjs-pino";

import { PROBLEM_CONTENT_TYPE, problem } from "@/common/utils/problem";

/**
 * HttpExceptions raised outside oRPC handlers (unknown routes, guards, health)
 * become problem+json. Errors inside oRPC handlers are converted in OrpcModule.
 */
@Catch(HttpException)
export class HttpExceptionsFilter implements ExceptionFilter<HttpException> {
  constructor(private readonly logger: Logger) {}

  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const request = ctx.getRequest<FastifyRequest>();
    const response = ctx.getResponse<FastifyReply>();

    const statusCode = exception.getStatus();
    const body = exception.getResponse();
    const detail =
      typeof body === "object" && body !== null && "message" in body
        ? String((body as { message: unknown }).message)
        : exception.message;

    if (statusCode >= 500) {
      this.logger.error(
        { path: request.url, err: exception },
        "HttpExceptionsFilter",
      );
    }

    response
      .status(statusCode)
      .header("content-type", PROBLEM_CONTENT_TYPE)
      .send(
        JSON.stringify(
          problem({ status: statusCode, detail, instance: request.url }),
        ),
      );
  }
}
