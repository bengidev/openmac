# openmac

## Development

### SwiftFormat

This project runs SwiftFormat automatically in two places:

1. Xcode build: the `OpenMac` target has a `SwiftFormat` Run Script phase before `Sources`.
2. Git pre-commit: staged Swift files are formatted and re-staged before commit.

Install SwiftFormat if needed:

```sh
brew install swiftformat
```

Enable the repository Git hooks for a fresh clone:

```sh
Scripts/install-git-hooks.sh
```

The formatting rules live in `.swiftformat`.
