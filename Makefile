ifndef VERBOSE
.SILENT:
endif

pgtap-image:
	podman build -t pgtap -f ./development/containers/pgtap.dockerfile

pgtap-tests:
	podman run --rm --detach \
	--name=pgtap-container \
	--volume ./database/:/scripts/:Z \
	--env POSTGRES_USER=test \
	--env POSTGRES_PASSWORD=testpass \
	pgtap > /dev/null
#TODO: actually check if the db is up yet.
	echo "creating test database..."
	sleep 5
	podman exec -it pgtap-container psql -U test -Xf /scripts/dbinit.sql > /dev/null
	echo "running tests..."
	echo
	podman exec -it pgtap-container psql -U test -Xf /scripts/tests/run-tests.sql
	echo
	echo "throwing out test database..."
	podman rm -f pgtap-container > /dev/null