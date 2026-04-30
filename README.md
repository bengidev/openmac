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

### VS Code

Run the app from VS Code in either of these ways:

1. Run and Debug sidebar:
   - choose `Run OpenMac` from the launch dropdown
   - press the green play button
2. Build task:
   - press `Cmd+Shift+B`, or run `Tasks: Run Task` from the command palette
   - choose `Run OpenMac`

Available launch configs:

- `Run OpenMac`: builds and launches the macOS app through the integrated terminal.
- `Debug OpenMac`: builds first, then launches the app executable through CodeLLDB.

Available tasks:

- `Run OpenMac`: builds and launches the macOS app.
- `Build OpenMac`: builds without launching.
- `Clean Build OpenMac`: cleans and builds without launching.

The VS Code configs call `Scripts/vscode-run.sh`. You can also run it directly:

```sh
Scripts/vscode-run.sh
```
