import { Inject } from '@nestjs/common';
import { DRIZZLE } from './database.module.js';

/** Injects the Drizzle client: `constructor(@InjectDb() private db: Database) {}` */
export const InjectDb = () => Inject(DRIZZLE);
