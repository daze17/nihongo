import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { PROBLEM_CONTENT_TYPE, problem } from './problem.js';

/**
 * Formats errors raised outside oRPC handlers (unknown routes, health checks, guards)
 * as problem+json. Errors inside oRPC handlers are converted in orpc.module.ts.
 */
@Catch()
export class ProblemDetailsFilter implements ExceptionFilter {
  private readonly logger = new Logger(ProblemDetailsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest<Request>();
    const res = ctx.getResponse<Response>();

    const status =
      exception instanceof HttpException ? exception.getStatus() : HttpStatus.INTERNAL_SERVER_ERROR;
    const body = exception instanceof HttpException ? exception.getResponse() : undefined;
    const message =
      typeof body === 'object' && body !== null && 'message' in body
        ? String((body as { message: unknown }).message)
        : (exception as Error)?.message;

    if (status >= 500) this.logger.error(exception);

    res
      .status(status)
      .type(PROBLEM_CONTENT_TYPE)
      .json(problem({ status, detail: message, instance: req.originalUrl }));
  }
}
