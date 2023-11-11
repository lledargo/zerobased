SAVEPOINT test;

-- Declare the number of tests.
SELECT plan(1);

-- Run the tests.
SELECT pass( 'pgTAP is working' );

-- Finish the tests and clean up.
SELECT * FROM finish();
ROLLBACK TO SAVEPOINT test;