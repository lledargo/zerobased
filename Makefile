ifeq ($(shell ls local.mk 2> /dev/null),local.mk)
include local.mk
endif

ifndef VERBOSE
.SILENT:
endif

.PHONY:default
default: pgtap-tests

.PHONY: clean
clean:
#containers
	podman rm -f pgtap-container
	podman rm -f zbdb-dev
#pods
	podman pod rm -f zb-dev
#persistent volumes
	if [[ $$(podman volume ls -qf name=zbdb-data) == "zbdb-data" ]]; \
	then podman volume rm zbdb-data; fi
#images
ifndef KEEP_ALL_IMGS
	podman rmi -f localhost/pgtap:latest
ifndef KEEP_BASE_IMGS
	if [[ $$(podman ps -a | grep "docker.io/library/postgres:16") == "" ]]; \
	then podman rmi -f docker.io/library/postgres:16; fi
endif
endif
# files and directories
	rm -rf development/var

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

.PHONY: dev-deploy
dev-deploy:
	if [[ ! -d ./development/var/pgdata ]]; then mkdir -p development/var/pgdata; fi
	podman pod create --name=zb-dev -p 8080:8080 -p 4200:4200
	podman run --rm --detach \
	--pod=zb-dev \
	--name=zbdb-dev \
	--volume ./database/:/scripts/:Z \
	--volume zbdb-data:/var/lib/postgresql/data:Z \
	--env POSTGRES_USER=test \
	--env POSTGRES_PASSWORD=testpass \
	postgres:16
	sleep 5
	podman exec -it zbdb-dev psql -U test -Xf /scripts/dbinit.sql