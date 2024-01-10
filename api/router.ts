import { Router } from "https://deno.land/x/oak@v12.6.1/mod.ts";
import OptionsController from "./modules/options/options.controller.ts";
import AccountController from "./modules/account/account.controller.ts";

const router = new Router();

  router.options("/", OptionsController.list);

  router.get("/accounts", AccountController.list);

export default router;