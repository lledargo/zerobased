import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";
import { Account } from "../../../../common/types/account.dto";
import { environment } from "../../environments/environment";

const api_address = environment.apiUrl;

@Injectable()
export class AccountClient {
  constructor(private httpClient: HttpClient) {}

  list() {
    return this.httpClient.get(api_address + "/accounts");
  }
}