import {Client} from "https://deno.land/x/postgres@v0.17.0/mod.ts";

const database = new Client();

await database.connect();

export default database;