import type { Env } from './env.js';

/** Injectable, typed view of the validated environment. */
export class AppConfig {
  constructor(readonly env: Env) {}

  get isProduction() {
    return this.env.NODE_ENV === 'production';
  }
}
