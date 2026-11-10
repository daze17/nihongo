/** Name of the OpenAPI security scheme for Auth0 access tokens. */
export const BEARER_AUTH = "auth0";

/** Marks a route as needing `Authorization: Bearer <Auth0 access token>` in openapi.json. */
export const requiresAuth = (op: object) => ({
  ...op,
  security: [{ [BEARER_AUTH]: [] }],
});
