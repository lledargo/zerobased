import { Application } from "https://deno.land/x/oak@v12.6.1/mod.ts";
import router from "./router.ts";
import { superoak } from "https://deno.land/x/superoak@4.7.0/mod.ts";

const app = new Application();
app.use(router.routes());
app.use(router.allowedMethods());

Deno.test("options test", async () => {
  const request = await superoak(app);
  await request.options("/").expect(200).expect('Access-Control-Allow-Methods','GET, POST, DELETE, PATCH, OPTIONS');
});