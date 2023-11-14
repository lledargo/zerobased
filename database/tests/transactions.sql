SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(11);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'transactions',
    ARRAY[ 'id', 'primary_account_id', 'date', 'cleared', 'reconciled' ]
);

SELECT col_is_pk('transactions','id');
SELECT col_isnt_pk('transactions',
ARRAY['primary_account_id','date','cleared','reconciled']);

SELECT col_type_is('transactions','primary_account_id','integer');
SELECT col_type_is('transactions','date','date');
SELECT col_type_is('transactions','cleared','boolean');
SELECT col_type_is('transactions','reconciled','boolean');

SELECT col_not_null('transactions','date');
SELECT col_has_default('transactions','date');

SELECT col_has_default('transactions','cleared');

SELECT col_has_default('transactions','reconciled');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;