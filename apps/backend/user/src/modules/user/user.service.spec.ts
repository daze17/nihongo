import { ORPCError } from "@orpc/nest";
import type { User as UserRow } from "@repo/db";

import type { UserRepository } from "./user.repository";
import { UserService } from "./user.service";

const row = (overrides: Partial<UserRow> = {}): UserRow => ({
  id: "0b7c2a4e-1d3f-4a5b-8c9d-0e1f2a3b4c5d",
  auth0Sub: "google-oauth2|1",
  email: "bat@example.mn",
  emailVerified: true,
  name: "Бат",
  pictureUrl: null,
  createdAt: new Date("2026-10-25T00:00:00Z"),
  updatedAt: new Date("2026-10-25T00:00:00Z"),
  deletedAt: null,
  ...overrides,
});

const claims = {
  sub: "google-oauth2|1",
  email: "bat@example.mn",
  emailVerified: true,
  name: "Бат",
  picture: null,
};

describe("UserService.me", () => {
  it("upserts by Auth0 subject and returns the contract shape", async () => {
    const upsertFromAuth = jest.fn(async () => row());
    const repository = { upsertFromAuth } as unknown as UserRepository;

    const user = await new UserService(repository).me(claims);

    expect(upsertFromAuth).toHaveBeenCalledWith({
      auth0Sub: "google-oauth2|1",
      email: "bat@example.mn",
      emailVerified: true,
      name: "Бат",
      pictureUrl: null,
    });
    expect(user).toEqual({
      id: "0b7c2a4e-1d3f-4a5b-8c9d-0e1f2a3b4c5d",
      email: "bat@example.mn",
      emailVerified: true,
      name: "Бат",
      pictureUrl: null,
      createdAt: "2026-10-25T00:00:00.000Z",
    });
  });

  it("refuses deleted accounts", async () => {
    const repository = {
      upsertFromAuth: async () => row({ deletedAt: new Date() }),
    } as unknown as UserRepository;
    const error = await new UserService(repository)
      .me(claims)
      .catch((e: unknown) => e);
    expect(error).toBeInstanceOf(ORPCError);
    expect((error as ORPCError<string, unknown>).code).toBe("FORBIDDEN");
  });
});
