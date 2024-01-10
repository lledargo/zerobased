import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Account } from "../../../../common/types/account.dto";

const url = "http://localhost:8080";

@Injectable()
export class AccountClient {
  constructor(private httpClient: HttpClient) {}

  list() {
    return this.httpClient.get(url + "/accounts");
  }
}
