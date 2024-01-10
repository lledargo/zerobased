import AccountRepository from "./account.repository.ts";
import { Account } from "../../../common/types/account.dto.ts";

class AccountService {
  async list(): Promise<Array<Account>> {
    const data = await AccountRepository.list();
    return data.rows;
  }
}

export default new AccountService();