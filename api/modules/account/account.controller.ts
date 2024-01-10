import { Context } from "https://deno.land/x/oak@v12.6.1/mod.ts";
import AccountService from "./account.service.ts";

class AccountController {
  async list(ctx: Context) {
    ctx.response.status = 200;
    ctx.response.body = {
      meta: {
        code: 200,
        status: "Ok",
      },
      data: await AccountService.list(),
    };
  }
}

export default new AccountController();
