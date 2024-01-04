# zerobased
A zero based budgeting application

## Developement Notes

#### Deno and VSCode

There is a language server client which adds support for deno to VSCode. https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno
It is possible to enable globablly, but you can enable it for this project only by adding the following to `./.vscode/settings.json`
```
{
  "deno.enable": true,
  "deno.enablePaths": ["./api"]
}
```

### Using Make
#### Receipes overview

Some make receipes are defined to help with the development workflow.

- `clean` - removes any thing make may have created (i.e. contianers, pods, container images and volumes, files/directories)
- `make tests` - Runs all tests (Deno, and Postgres).
- `dev-deploy` - Provisions a pod (zb-dev) with a development database in a container (zbdb-dev), and a development API in a container (zbapi-dev).

#### Make options

There are some options to control the behavior of the make receipes which can be declared in a `local.mk` file and/or overridden in the command line while running make (e.g. `make VERBOSE=true`). 

The following options are off by default and enabled when defined:

- `VERBOSE` - Disables the `.SILENT` special target, which prevents make from echoing the receipe steps as it runs.
- `KEEP_ALL_IMGS` - Skips the portion of `make clean` which deletes container images, including base images.
- `KEEP_BASE_IMGS` - Skips the portion of `make clean` which deletes base container images. (i.e `postgres:16`,`deno:latest`)

### Tests
#### Database unit testing

Database unit tests use the pgTAP framework and can be found in `./database/tests/`. You can easily spin up a container in podman, with pgTAP installed and run the tests with the help of some make receipes. Run `make pgtap-tests` to instantiate a container and run the tests. `pgtap-tests` will also run the `pgtap-image` target which builds the pgTAP container image if it does not already exist.

#### Deno API unit testing

API tests are performed by deno's built in testing framework. superoak is used to run the app and mock requests. `deno task test` in the api directory will run the tests using the `--allow-net` option; doing so will some ephemeral ports for a short period. The Makefile in the project root directory  inculdes a `deno-tests` receipe to run the tests.