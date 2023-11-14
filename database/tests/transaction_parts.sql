SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(10);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'transaction_parts',
    ARRAY[ 'id', 'parent_id', 'secondary_account_id', 'category_id', 'credit', 'debit', 'memo']
);

SELECT col_is_pk('transaction_parts','id');
SELECT col_isnt_pk('transaction_parts',
ARRAY['parent_id','secondary_account_id','category_id','credit','debit','memo']);

SELECT col_type_is('transaction_parts','parent_id','integer');
SELECT col_type_is('transaction_parts','secondary_account_id','integer');
SELECT col_type_is('transaction_parts','category_id','integer');
SELECT col_type_is('transaction_parts','credit','money');
SELECT col_type_is('transaction_parts','debit','money');
SELECT col_type_is('transaction_parts','memo','varchar(50)');

SELECT col_has_default('transaction_parts','category_id');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;