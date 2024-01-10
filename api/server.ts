import { Application } from "https://deno.land/x/oak@v12.6.1/mod.ts";
import router from "./router.ts"

const app = new Application();

app.use(async (ctx, next) => {
  await next();
  console.log(Date.now()+" - "+ctx.request.method+" - "+ctx.request.headers.get("host")+ctx.request.url.pathname+" -- Res "+ctx.response.status);
});
app.use(async (ctx, next) => {
  ctx.response.headers.set("Access-Control-Allow-Origin", "http://localhost:4200");
  await next();
});
app.use(router.routes());
app.use(router.allowedMethods());

app.listen({ port: 8080 });
console.log(`Listening on localhost:${8080}`);

export default app;