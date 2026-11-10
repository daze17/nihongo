import { oc } from "@orpc/contract";

import { MeResponseBody } from "@/schemas/dtos/users";
import { requiresAuth } from "./auth";

export const usersContract = {
  me: oc
    .route({
      method: "GET",
      path: "/v1/me",
      summary:
        "Signed-in user. Created on the first call after an Auth0 sign-in.",
      tags: ["users"],
      spec: requiresAuth,
    })
    .output(MeResponseBody),
};
