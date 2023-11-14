CREATE ROLE zerobased LOGIN;

CREATE DATABASE zerobased OWNER zerobased;

\connect zerobased zerobased
CREATE SCHEMA default_budget;

ALTER ROLE zerobased IN DATABASE zerobased SET search_path TO default_budget, public;
/* reconnect so postgres uses our new search path */
\connect zerobased zerobased 

CREATE TYPE account_types AS ENUM ('checking','saving','cash','credit card','line of credit','loan','asset','liability','external','special');

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    internal BOOLEAN,
    type account_types,
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE master_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(25),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    master INTEGER,
    name VARCHAR(25),
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    primary_account_id INTEGER,
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    cleared BOOLEAN DEFAULT FALSE,
    reconciled BOOLEAN DEFAULT FALSE
);

CREATE TABLE transaction_parts (
    id SERIAL PRIMARY KEY,
    parent_id INTEGER,
    secondary_account_id INTEGER,
    category_id INTEGER DEFAULT 1,
    credit MONEY,
    debit MONEY,
    memo VARCHAR(50)
);

CREATE TABLE assignments (
    id SERIAL PRIMARY KEY,
    category_id INTEGER,
    credit MONEY,
    debit MONEY,
    date DATE NOT NULL DEFAULT CURRENT_DATE
);