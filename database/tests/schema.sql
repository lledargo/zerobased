SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(4);

-- Run the tests.
SELECT roles_are(ARRAY['postgres','zerobased',
'pg_checkpoint',
'pg_create_subscription',
'pg_database_owner',
'pg_execute_server_program',
'pg_monitor',
'pg_read_all_data',
'pg_read_all_settings',
'pg_read_all_stats',
'pg_read_server_files',
'pg_signal_backend',
'pg_stat_scan_tables',
'pg_use_reserved_connections',
'pg_write_all_data',
'pg_write_server_files'
]);
SELECT schemas_are(ARRAY['public','default_budget']);
SELECT tables_are(ARRAY['accounts','master_categories','categories',
'transactions','transaction_parts','assignments']);
SELECT enums_are(ARRAY['account_types']);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;