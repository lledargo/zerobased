import { Component, OnInit } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterOutlet } from "@angular/router";
import { AccountClient } from "./core/account.client";
import Account from "../../../common/types/account.dto";
import { HttpClientModule } from "@angular/common/http";

@Component({
  selector: "app-root",
  standalone: true,
  imports: [CommonModule, RouterOutlet],
  templateUrl: "./app.component.html",
  styleUrl: "./app.component.css",
})
export class AppComponent implements OnInit {
  accounts: Array<Account> = [];
  
  title = "zerobased";

  constructor(private accountClient: AccountClient) {}

  ngOnInit(): void {
    this.accountClient.list()
      .subscribe((response: any) => {
        this.accounts = response.data;
        console.log(response.data);
      });
  }
}
