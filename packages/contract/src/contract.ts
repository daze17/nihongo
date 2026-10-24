import { contentContract } from './content.js';

/**
 * The whole API surface. Every endpoint is declared here first, then:
 * - apps/backend/user implements it with `@Implement(contract.x.y)`
 * - openapi.json is generated from it (Dart client for apps/mobile)
 * - apps/admin imports it for a fully typed oRPC client
 */
export const contract = {
  content: contentContract,
};

export type Contract = typeof contract;
