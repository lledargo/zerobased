SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(7);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'categories',
    ARRAY[ 'id', 'master', 'name', 'active' ]
);

SELECT col_is_pk('categories','id');
SELECT col_isnt_pk('categories',
ARRAY['master','name','active']);

SELECT col_type_is('categories','master','integer');
SELECT col_type_is('categories','name','varchar(25)');
SELECT col_type_is('categories','active','boolean');

SELECT col_has_default('categories','active');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;