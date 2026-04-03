set positional-arguments
set dotenv-load
set export

IMAGE := env_var_or_default("IMAGE", "debian-11")
IMAGE_SRC := env_var_or_default("IMAGE_SRC", "debian-11")
TEDGE_CHANNEL := "release"

build *ARGS:
    ./ci/build.sh {{ARGS}}

publish *ARGS:
    ./ci/publish.sh {{ARGS}}

# Install python virtual environment
venv:
  [ -d .venv ] || python3 -m venv .venv
  ./.venv/bin/pip3 install -r tests/requirements.txt

# Run tests
test *args='':
  ./.venv/bin/python3 -m robot.run --outputdir output {{args}} tests

build-test:
  docker build --load -t {{IMAGE}} --build-arg "{{TEDGE_CHANNEL}}" -f ./test-images/{{IMAGE_SRC}}/Dockerfile .
