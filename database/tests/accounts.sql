SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(8);

-- Run the tests.
SELECT columns_are(
    'default_budget',
    'accounts',
    ARRAY[ 'id', 'name', 'internal', 'type', 'active' ]
);

SELECT col_is_pk('accounts','id');
SELECT col_isnt_pk('accounts',
ARRAY['name','internal','type','active']);

SELECT col_type_is('accounts','name','varchar(20)');
SELECT col_type_is('accounts','internal','boolean');
SELECT col_type_is('accounts','type','account_types');
SELECT col_type_is('accounts','active','boolean');

SELECT col_has_default('accounts','active');

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;