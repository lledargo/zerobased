SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(6);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'master_categories',
    ARRAY[ 'id', 'name', 'active' ]
);

SELECT col_is_pk('master_categories','id');
SELECT col_isnt_pk('master_categories',
ARRAY['name','active']);

SELECT col_type_is('master_categories','name','varchar(25)');
SELECT col_type_is('master_categories','active','boolean');

SELECT col_has_default('master_categories','active');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;