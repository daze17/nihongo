import { Inject } from '@nestjs/common';
import { DRIZZLE } from './tokens.js';

/** Injects the Drizzle client: `constructor(@InjectDb() private db: Database) {}` */
export const InjectDb = () => Inject(DRIZZLE);
