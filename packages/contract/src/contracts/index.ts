import { contentContract } from "./content";
import { usersContract } from "./users";

export * from "./auth";
export * from "./content";
export * from "./users";

/**
 * The whole API surface. Every endpoint is declared here first, then:
 * - apps/backend/user implements it with `@Implement(contract.x.y)`
 * - openapi.json is generated from it (Dart client for apps/mobile)
 */
export const contract = {
  content: contentContract,
  users: usersContract,
};

export type Contract = typeof contract;
