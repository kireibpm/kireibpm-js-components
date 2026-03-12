# npm Publishing

## Required GitHub secrets

The release workflow expects these repository secrets:

- `NPM_TOKEN`: npm automation token with publish permission for `kireibpm-js-components`
- `KIREIBPM_CI_PAT`: optional GitHub PAT used to push the release commit and tag when `github.token` is not sufficient

## Release workflow

Use the `Release npm package` workflow from `main`.
The package published by this workflow is `@kireibpm/js-components`.

Inputs:

- `releaseType`: one of `patch`, `minor`, `major`, `prepatch`, `preminor`, `premajor`, `prerelease`
- `npmPublish`: `true` to publish the released version to npm after the release commit and tag are pushed

The workflow:

1. checks out the selected branch,
2. installs dependencies,
3. bumps the package version,
4. rebuilds and validates `dist/`,
5. creates a release commit and tag,
6. pushes the branch and tag,
7. optionally publishes to npm using `NPM_TOKEN`.

## Downstream consumption

Repositories that still import the package under the historical dependency key can switch from the GitHub tarball to npm without changing filesystem paths by using an alias:

```json
{
	"dependencies": {
		"bonita-js-components": "npm:@kireibpm/js-components@1.0.3"
	}
}
```

## Local validation

Before publishing manually, validate the package contents:

```bash
cd kireibpm-js-components
npm test
npm run dist
npm pack --dry-run
```

## Manual publishing

If you need to publish from a local machine instead of GitHub Actions:

```bash
cd kireibpm-js-components
npm adduser
./infrastructure/publish.sh
```
