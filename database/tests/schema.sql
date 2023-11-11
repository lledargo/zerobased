SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(8);

-- Run the tests.
SELECT tables_are( ARRAY['accounts','master_categories','categories',
'transactions','transaction_parts','assignments']);

SELECT columns_are(
    'public',
    'accounts',
    ARRAY[ 'id', 'name', 'internal', 'type', 'active' ]
);

SELECT columns_are(
    'public',
    'master_categories',
    ARRAY[ 'id', 'name', 'active' ]
);

SELECT columns_are(
    'public',
    'categories',
    ARRAY[ 'id', 'master', 'name', 'active' ]
);

SELECT columns_are(
    'public',
    'transactions',
    ARRAY[ 'id', 'primary_account_id', 'date', 'cleared', 'reconciled' ]
);

SELECT columns_are(
    'public',
    'transaction_parts',
    ARRAY[ 'id', 'parent_id', 'secondary_account_id', 'category_id', 'credit', 'debit', 'memo' ]
);

SELECT columns_are(
    'public',
    'assignments',
    ARRAY[ 'id', 'category_id', 'credit', 'debit', 'date' ]
);

SELECT enums_are(ARRAY['account_types']);

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;