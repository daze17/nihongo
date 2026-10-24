import {
  type ArgumentsHost,
  Catch,
  type ExceptionFilter,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { STATUS_CODES } from 'node:http';
import type { Request, Response } from 'express';

/** Renders every error as RFC 9457 problem+json so the Dart client has one error shape. */
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
    const extra =
      typeof body === 'object' && body !== null ? (body as Record<string, unknown>) : {};

    if (status >= 500) this.logger.error(exception);

    res
      .status(status)
      .type('application/problem+json')
      .json({
        type: 'about:blank',
        title: STATUS_CODES[status] ?? 'Error',
        status,
        detail:
          status >= 500
            ? 'Something went wrong on our side.'
            : (extra.message ?? (exception as Error).message),
        instance: req.originalUrl,
        ...(extra.errors ? { errors: extra.errors } : {}),
      });
  }
}
