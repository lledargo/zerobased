\unset ECHO
\set QUIET 1
-- Turn off echo and keep things quiet.

-- Format the output for nice TAP.
\pset format unaligned
\pset tuples_only true
\pset pager off

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP true

-- Load pgTAP and run the tests.
BEGIN;
\i /usr/share/postgresql/16/extension/pgtap.sql
\i /scripts/tests/pgtap-test.sql
\i /scripts/tests/schema.sql
\i /scripts/tests/accounts.sql
\i /scripts/tests/master_categories.sql
\i /scripts/tests/categories.sql
\i /scripts/tests/transactions.sql
\i /scripts/tests/transaction_parts.sql
\i /scripts/tests/assignments.sql
ROLLBACK;