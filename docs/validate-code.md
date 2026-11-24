# Enjamer Code Validation

Before pushing changes to the repository or creating a Pull Request, each developer must run the corresponding validation checks.

## Installing dependencies

```bash
  npm ci
```

> **Warning:** The validation commands below only work after you initialize the Enjamer CLI with `npm run enjamer-cli`, as described in the project setup documentation.
## Mandatory validations

| Command | Function |
| --- | --- |
| `enjamer-detectsLintErrors-code` | Detects ESLint errors and warnings. |
| `enjamer-checkFormat-code` | Checks that the code complies with Prettier rules. |
| `enjamer-checkBuild-code` | Checks that the project compiles correctly. |
| `enjamer-validate-commitMessages` | Validates the commit messages introduced by the current branch. |
| `enjamer-validate-branchName` | Validates the branch name and registered username. |
| `enjamer-validate-commitAuthors` | Validates commit authors against registered identities. |

All validations must complete successfully before requesting integration.

## Fixing formatting

If Prettier finds formatting issues, run:

```bash
  enjamer-fixFormat
```

Then repeat the validation.

## Commit validation

Commit messages must follow the conventions defined in the files within the project's `docs/` directory or directly in Enjamer's private documentation at `https://wiki.enjamer.com/`.

To validate a message before creating a commit:

```bash
echo "feat(config): add project setting" | enjamer-validate-currentCommit
```

To validate the most recent commit:

```bash
enjamer-validate-lastCommit
```

To validate all commits introduced by the current branch:

```bash
enjamer-validate-commitMessages
```

## Commit author validation

Every commit must use an authorized identity registered in `commit-authors.yml` or directly in Enjamer's private documentation at `https://wiki.enjamer.com/`.

Each identity includes:

- `name`: Developer's full name.
- `username`: Authorized Git author username.
- `email`: Authorized corporate email address.

Example:

```yaml
authors:
  - name: "John Doe Pérez Martínez"
    username: "jperezatenjamer"
    email: "jdperezm@enjamer.com"
```

To configure the mentioned credentials, visit `https://wiki.enjamer.com`

Validate all commit authors in the current branch:

```bash
enjamer-validate-commitAuthors
```

The validation fails if a commit contains an unregistered username and email combination.

## Branch name validation

Validate the current branch:

```bash
enjamer-validate-branchName
```

An invalid branch name causes the validation to fail.

## Registering a new developer identity

Developers who are not yet registered in `commit-authors.yml` must use the special branch:

```text
adding-new-identity
```

This branch is reserved exclusively for identity registration.

All commits in this branch must follow the format:

```text
chore(identity): add new developer
```

The branch validator rejects `adding-new-identity` if it contains commits with other types or scopes.

Automatic author validation is skipped for these identity-registration commits.

**Important:** Identity registration requires human review. Passing automated validation does not constitute approval of the new developer.

## Continuous Integration

All Pull Requests targeting `main` automatically undergo the following checks through GitHub Actions:

1. Branch name validation.
2. ESLint validation.
3. Prettier validation.
4. Commitlint validation.
5. Commit author validation.
6. Project build validation.

If any automated validation fails, the CI job fails.

**It is the responsibility of each developer to verify their changes locally before requesting integration.**

## Running all validations together

Before running the complete validation, install dependencies and update remote references:

```bash
npm ci
git fetch origin
```

Make sure your local `main` branch is up to date.

To run all six validations sequentially, execute the following command from the project root:

```bash
enjamer-validate-project
```

Each validation runs only if the previous one succeeds.

If a validation fails, execution stops immediately, and the terminal displays the corresponding error.

**Important:** Commit, branch, and author validation require the current branch to contain at least one commit and have a common history with `main`.

For accurate results, ensure that your local `main` reflects the latest remote changes before running these commands.
