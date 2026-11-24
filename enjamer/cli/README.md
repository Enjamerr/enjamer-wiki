# Enjamer CLI

**License:** Copyright © 2026 Enjamer. All rights reserved. Licensed for internal use by Enjamer.

The Enjamer CLI provides a standard set of local validation commands for projects generated from the Enjamer React JS template. Developers use it to validate their code before opening a pull request.

From the root of a generated React JS project, run:

```sh
npm run enjamer-cli
```

The command detects your operating system and runs the installer for your user.

- Linux with Bash or Zsh installs into `~/.local/bin` and configures the shell startup files.
- Windows installs into `%LOCALAPPDATA%\Enjamer\bin` and updates the user PATH. The launchers require Git for Windows with Git Bash.

Open a new terminal after installation. Run the same setup command again to update the installed commands without adding another PATH entry.

Run the installed commands from the root of the project you want to validate after installing its dependencies with `npm ci --include=dev`. You can move the project and run the same commands from its new directory.

```sh
enjamer-validate-project
echo "feat(config): add project setting" | enjamer-validate-currentCommit
enjamer-validate-lastCommit
```

See the [code validation guide](../../docs/validate-code.md) for the full list.
