# zerobased
A zero based budgeting application

## Developement Notes
### Tests
#### Database unit testing

Database unit tests use the pgTAP framework and can be found in `./database/tests/`. You can easily spin up a container in podman, with pgTAP installed and run the tests with the help of some make commands. `make pgtap-image` will build the dockerfile `./development/containers/pgtap.dockerfile`. Once the container image is built, run `make pgtap-tests` to instantiate a container and run the tests.