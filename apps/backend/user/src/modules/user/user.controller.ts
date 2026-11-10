import { Controller, Req } from "@nestjs/common";
import { Implement, implement } from "@orpc/nest";
import { contract } from "@repo/contract";

import { type AuthedRequest, authOf } from "@/common/types/authed_request";

import { UserService } from "./user.service";

/** Implements `contract.users`. Protected by the global Auth0 guard. */
@Controller()
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Implement(contract.users)
  router(@Req() request: AuthedRequest) {
    const claims = authOf(request);
    return {
      me: implement(contract.users.me).handler(() =>
        this.userService.me(claims),
      ),
    };
  }
}
