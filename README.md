@kireibpm/js-components
=======================

KireiBPM AngularJS components library.

This repository is a rebranded fork of `bonita-js-components`.
The distributed bundle keeps the historical `bonita-lib*` artifact names for compatibility with existing consumers.
The npm package is published as `@kireibpm/js-components`.

## Requirements

You need Node.js, Yarn and npm.

The repository is maintained and packed with Node 18+ and Yarn 1.22+.

The library targets AngularJS 1.x applications and is currently consumed by KireiBPM UI Designer.

## Included components

 - [x] bo-sortable (bo-sortable sort-options="sortOptions" on-sort="onSort( options)")
 - [x] bo-storable (bo-storable="storageId" on-storage-loaded="loadContent()")
 - [x] bo-sorter (default id=key, or bo-sorter='key')
 - [x] selectAll (bo-selectable, bo-selectAll, bo-selector)
 - [x] bo-repeatable
 - [x] table-settings 
 - [x] drag and drop
 - [x] draggable-columns (need to add ng-sortable dependency to make it work as it is not imported by default)

## Available commands

First, run `yarn install` to install dependencies.

- `$ npm start`: launch the development environment with a local server and livereload
- `$ npm run dist`: regenerate the `dist/` bundle that is shipped to consumers
- `$ npm test`: run the Karma test suite
- `$ npm run documentation`: generate the ngdoc site inside `./docs/`
 
## Todo

 - [ ] kireibpm.resizable (see http://bz.var.ru/comp/web/resizable.html )

## Publishing a new version

The published package contains only the prebuilt assets from `dist/` plus package metadata.

The recommended release path is the `Release npm package` GitHub Actions workflow from `main`, described in [docs/npm-publishing.md](docs/npm-publishing.md).

When you're ready to ship a new version:

0. Bump the version in `package.json` and regenerate the distribution files.

1. Build and verify the package.
```console
$ yarn install
$ npm run dist
$ npm test
$ npm pack --dry-run
```

2. Publish the package to npm.
```console
$ npm publish
```

3. Update downstream repositories to consume the published version instead of a GitHub tarball.

	Existing consumers can keep the dependency key `bonita-js-components` by using an npm alias such as `bonita-js-components@npm:@kireibpm/js-components@<version>`.

The code coverage site is generated when you run tests and is available under `./coverage/`.

## Documentation
To ease the documentation process:
```console
$ npm run documentation
```
This runs a local server with livereload and regenerates docs when source files change.

## Code coverage
The Karma test suite provides code coverage through karma-istanbul. The generated coverage site is located in `./coverage/`.
