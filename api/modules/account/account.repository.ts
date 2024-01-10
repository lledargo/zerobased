import database from "../../dbconn.ts";
import { QueryObjectResult } from "https://deno.land/x/postgres@v0.17.0/query/query.ts";

class AccountRepository {
  async list(): Promise<QueryObjectResult> {
    return await database.queryObject("SELECT * FROM accounts;");
  }
}

export default new AccountRepository();
