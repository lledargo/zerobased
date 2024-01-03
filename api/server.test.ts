import * as assert from "https://deno.land/std@0.204.0/assert/mod.ts";
import app from "./server.ts";

Deno.test("App exists", () => {
  assert.assertEquals(typeof({}),typeof(app));
});
