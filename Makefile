ifndef VERBOSE
.SILENT:
endif

.PHONY: clean
clean:
	podman rm -f pgtap-container
	podman rmi -f localhost/pgtap:latest
ifeq ($(shell podman ps -a | grep "docker.io/library/postgres:16"),)
	podman rmi -f docker.io/library/postgres:16
endif

.PHONY: pgtap-image
pgtap-image:	
ifeq ($(shell podman images -q localhost/pgtap:latest),)
	podman build -t pgtap -f ./development/containers/pgtap.dockerfile
else
	echo "using existing pgtap container image"
endif

.PHONY: pgtap-tests
pgtap-tests: pgtap-image
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