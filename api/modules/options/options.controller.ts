import { Context } from "https://deno.land/x/oak@v12.6.1/context.ts";

class OptionsController {
    list(ctx: Context){
        ctx.response.status = 200;
        ctx.response.headers.set("Access-Control-Allow-Headers", "content-type");
        ctx.response.headers.set("Access-Control-Allow-Methods", "GET, POST, DELETE, PATCH, OPTIONS");
        }
}

export default new OptionsController();