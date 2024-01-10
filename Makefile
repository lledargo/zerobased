ifeq ($(shell ls local.mk 2> /dev/null),local.mk)
include local.mk
endif

ifndef VERBOSE
.SILENT:
endif

.PHONY:default
default: dev-deploy

.PHONY: clean
clean:
#containers
	podman rm -f zb-pgtap-test
	podman rm -f zb-deno-test-db
	podman rm -f zb-deno-test
	podman rm -f zb-ng-test
	podman rm -f zbdb-dev
	podman rm -f zbapi-dev
	podman rm -f zbweb-dev
#pods
	podman pod rm -f zb-api-test
	podman pod rm -f zb-dev
#persistent volumes
	if [[ $$(podman volume ls -qf name=zbdb-data) == "zbdb-data" ]]; \
	then podman volume rm zbdb-data; fi
#images
ifndef KEEP_ALL_IMGS
	podman rmi -f localhost/pgtap:latest
	podman rmi -f localhost/ng:latest
ifndef KEEP_BASE_IMGS
	if [[ $$(podman ps -a | grep "docker.io/library/postgres:16") == "" ]]; \
	then podman rmi -f docker.io/library/postgres:16; fi
	if [[ $$(podman ps -a | grep "docker.io/denoland/deno:latest") == "" ]]; \
	then podman rmi -f docker.io/denoland/deno:latest; fi
	if [[ $$(podman ps -a | grep "docker.io/library/node:latest") == "" ]]; \
	then podman rmi -f docker.io/library/node:latest; fi
endif
endif
# files and directories
	rm -rf development/var

###
#container image receipes
###

.PHONY: pgtap-image
pgtap-image:	
ifeq ($(shell podman images -q localhost/pgtap:latest),)
	podman build -t pgtap -f ./development/containers/pgtap.dockerfile
else
	echo "using existing pgtap container image"
endif

.PHONY: ng-image
ng-image:
ifeq ($(shell podman images -q localhost/ng:latest),)
	podman build -t ng -f ./development/containers/ng.dockerfile
else
	echo "using existing ng container image"
endif

###
#test receipes
###

.PHONY: tests
tests: pgtap-tests deno-tests ng-tests

.PHONY: pgtap-tests
pgtap-tests: pgtap-image
	podman run --rm --detach \
	--name=zb-pgtap-test \
	--volume ./database/:/scripts/:Z \
	--env POSTGRES_USER=postgres \
	--env POSTGRES_PASSWORD=testpass \
	localhost/pgtap:latest > /dev/null
#TODO: actually check if the db is up yet.
	echo "creating test database..."
	sleep 5
	podman exec -it zb-pgtap-test psql -U postgres -Xf /scripts/dbinit.sql > /dev/null
	echo "running tests..."
	echo
	podman exec -it zb-pgtap-test psql -U postgres -d zerobased -c 'ALTER ROLE postgres IN DATABASE zerobased SET search_path to default_budget, public;'
	podman exec -it zb-pgtap-test psql -U postgres -d zerobased -Xf /scripts/tests/run-tests.sql
	echo
	echo "throwing out test database..."
	podman rm -f zb-pgtap-test > /dev/null

.PHONY: deno-tests
deno-tests:
	podman run --rm --detach \
		--pod=new:zb-api-test \
		--name=zb-deno-test-db \
		--volume ./database/:/scripts/:Z \
		--env POSTGRES_USER=postgres \
		--env POSTGRES_PASSWORD=testpass \
		postgres:16

	sleep 5
	podman exec -it zb-deno-test-db psql -U postgres -Xf /scripts/dbinit.sql
	sleep 5

	podman run \
		--rm --interactive --tty \
		--pod=zb-api-test \
		--name=zb-deno-test \
    --volume ./api:/app:Z \
    --volume ./api/.deno:/deno-dir:Z \
		--volume ./common:/common:Z \
    --workdir /app \
		-e PGUSER=zerobased \
		-e PGDATABASE=zerobased \
		-e PGHOST=localhost \
		-e PGPASSWORD=testpass \
		-e PGPORT=5432 \
    denoland/deno:latest \
		deno test --allow-net --allow-env --allow-read

	podman rm -f zb-deno-test-db
	podman rm -f zb-deno-test
	podman pod rm -f zb-api-test

.PHONY: ng-tests 
ng-tests: ng-image
	podman run \
		--rm --interactive --tty \
		--name=zb-ng-test \
		--volume ./web:/app:Z \
		--volume ./common:/common:Z \
		--workdir /app \
		-p 9876:9876 \
		localhost/ng:latest \
		ng test --browsers ChromeHeadless 

###
#dev receipes
###

.PHONY: dev-deploy
dev-deploy: dev-pod dev-db dev-api dev-web

.PHONY: dev-pod
dev-pod:
	podman pod create --name=zb-dev -p 8080:8080 -p 4200:4200

.PHONY: dev-db
dev-db: dev-pod
	if [[ ! -d ./development/var/pgdata ]]; then mkdir -p development/var/pgdata; fi
	podman run --rm --detach \
	--pod=zb-dev \
	--name=zbdb-dev \
	--volume ./database/:/scripts/:Z \
	--volume zbdb-data:/var/lib/postgresql/data:Z \
	--env POSTGRES_USER=postgres \
	--env POSTGRES_PASSWORD=testpass \
	postgres:16
	sleep 5
	podman exec -it zbdb-dev psql -U postgres -Xf /scripts/dbinit.sql

.PHONY: dev-api
dev-api: dev-pod
	podman run \
    --rm --detach \
		--pod=zb-dev \
		--name=zbapi-dev \
    --volume ./api:/app:Z \
    --volume ./api/.deno:/deno-dir:Z \
		--volume ./common:/common:Z \
    --workdir /app \
    -e PGUSER=zerobased \
		-e PGDATABASE=zerobased \
		-e PGHOST=localhost \
		-e PGPASSWORD=testpass \
		-e PGPORT=5432 \
    denoland/deno:latest \
    deno run --watch --allow-net --allow-env --allow-read server.ts

.PHONY: dev-web
dev-web: ng-image dev-pod
	podman run \
		--rm --detach \
		--pod=zb-dev \
		--name=zbweb-dev \
		--volume ./web:/app:Z \
		--volume ./common:/common:Z \
		--workdir /app \
		localhost/ng:latest \
		ng serve --host 0.0.0.0