import { Router } from "https://deno.land/x/oak@v12.6.1/mod.ts";
import OptionsController from "./modules/options/options.controller.ts";

const router = new Router();

  router.options("/", OptionsController.list)

export default router;