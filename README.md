# asdf-ticgit [![Build](https://github.com/bosmak/asdf-ticgit/actions/workflows/build.yml/badge.svg)](https://github.com/bosmak/asdf-ticgit/actions/workflows/build.yml) [![Lint](https://github.com/bosmak/asdf-ticgit/actions/workflows/lint.yml/badge.svg)](https://github.com/bosmak/asdf-ticgit/actions/workflows/lint.yml)

[asdf-vm](https://asdf-vm.com) plugin for [ticgit](https://github.com/schacon/ticgit) — a Git-native distributed ticketing system.

## Install

```shell
asdf plugin add ticgit https://github.com/bosmak/asdf-ticgit.git
```

## Usage

```shell
asdf list all ticgit          # List all available versions
asdf install ticgit latest    # Install the latest version
asdf global ticgit latest     # Set it as the default
```

Then use `ti` anywhere:

```shell
ti init
ti new --title "fix the parser" --tags bug,parser
ti list
```

See the [ticgit README](https://github.com/schacon/ticgit) for full usage documentation.

## Contributing

1. Install the lint/format tools:

    ```shell
    asdf plugin add shellcheck https://github.com/luizm/asdf-shellcheck.git
    asdf plugin add shfmt https://github.com/luizm/asdf-shfmt.git
    asdf install
    ```

1. Develop!

1. Lint & Format:

    ```shell
    ./scripts/format.bash
    ./scripts/lint.bash
    ```

1. PR changes
