SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(9);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'assignments',
    ARRAY[ 'id', 'category_id', 'credit', 'debit', 'date' ]
);

SELECT col_is_pk('assignments','id');
SELECT col_isnt_pk('assignments',
ARRAY['category_id','credit','debit','date']);

SELECT col_type_is('assignments','category_id','integer');
SELECT col_type_is('assignments','credit','money');
SELECT col_type_is('assignments','debit','money');
SELECT col_type_is('assignments','date','date');

SELECT col_has_default('assignments','date');
SELECT col_not_null('assignments','date');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;