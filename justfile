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
  docker build -t tedge-monit-setup-debian-11 -f ./test-images/debian-11/Dockerfile .
