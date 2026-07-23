[![CI](https://github.com/bigtalk-org/docker-nagini/actions/workflows/ci.yml/badge.svg)](https://github.com/bigtalk-org/docker-nagini/actions/workflows/ci.yml)
[![Upstream Sync](https://github.com/bigtalk-org/docker-nagini/actions/workflows/upstream-sync.yml/badge.svg)](https://github.com/bigtalk-org/docker-nagini/actions/workflows/upstream-sync.yml)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

# docker-nagini

Ready-to-use Docker container for [Nagini](https://github.com/marcoeilers/nagini), the formal verification tool for Python 3 built on the Viper infrastructure.

Pre-packaged with Python 3.12, OpenJDK 17, Z3 solver, Boogie, and Mono. No local toolchain configuration required.

---

## Quickstart

Run verification on your Python file by mounting your project directory to `/code`:

```bash
docker run --rm -v $(pwd):/code ghcr.io/bigtalk-org/docker-nagini tests/sample_test.py
```

---

## Selecting a Verification Backend

Nagini supports two verification backends depending on your workload:

### 1. Silicon Backend (Default)
Uses symbolic execution via Z3. Best for general contract verification.

```bash
docker run --rm -v $(pwd):/code ghcr.io/bigtalk-org/docker-nagini:silicon tests/sample_test.py
```

### 2. Carbon Backend
Uses verification condition generation via Boogie and Z3.

```bash
docker run --rm -v $(pwd):/code ghcr.io/bigtalk-org/docker-nagini:carbon --verifier carbon tests/sample_test.py
```

---

## Server & IDE Integrations

The container includes full support for background verification servers and IDE protocols.

### Nagini Server Mode (`--server`)
Runs a persistent verification server listening on port `5555` for socket requests:

```bash
docker run --rm -p 5555:5555 -v $(pwd):/code ghcr.io/bigtalk-org/docker-nagini --server
```

### Viper Caching Server (`--viper-server`)
Enables in-process result caching and fast re-verification across multiple runs:

```bash
docker run --rm -v $(pwd):/code ghcr.io/bigtalk-org/docker-nagini --viper-server tests/sample_test.py
```

### Language Server Protocol (`nagini_lsp`)
Connects Nagini to IDEs (VS Code, Neovim, Emacs) over stdio:

```bash
docker run -i --rm ghcr.io/bigtalk-org/docker-nagini nagini_lsp
```

### Model Context Protocol (`nagini_mcp`)
Runs Nagini as an MCP server for agent tool calls:

```bash
docker run -i --rm ghcr.io/bigtalk-org/docker-nagini nagini_mcp
```

---

## Building a Specific Nagini Version

Build locally against any PyPI version release or upstream git commit hash:

```bash
# Build specific PyPI release version
docker build --build-arg NAGINI_REF=1.2.0 -t docker-nagini:1.2.0 -f Dockerfile .

# Build specific upstream commit hash
docker build --build-arg NAGINI_REF=master -t docker-nagini:master -f Dockerfile .
```

---

## Running in GitHub Actions CI

Add Nagini verification to your repository CI workflow:

```yaml
name: Formal Verification

on: [push, pull_request]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Run Nagini verifier
        run: |
          docker run --rm -v ${{ github.workspace }}:/code ghcr.io/bigtalk-org/docker-nagini:latest src/main.py
```

---

## Development

Local Makefile shortcuts for development and testing:

* `make build`: Build local Silicon container image.
* `make build-carbon`: Build local Carbon container image.
* `make test`: Run local contract test suite.
* `make lint`: Run pre-commit style and syntax checks.
* `make cz-commit`: Format commit message using Conventional Commits.

---

## License

Apache License 2.0. Nagini, Viper, Z3, and underlying tools retain their original open-source licenses.
