import { SetMetadata } from "@nestjs/common";

export const IS_PUBLIC_KEY = "isPublic";

/** Opts a controller or route out of the global Auth0 guard. */
export const Public = () => SetMetadata(IS_PUBLIC_KEY, true);
