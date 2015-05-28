# Jitterbug

Jitterbug is a game inspired by an old Java homework assignment
that we had in college.

Play online at
[http://jitterbug.sortelli.com](http://jitterbug.sortelli.com).

## Running in developer mode

### Setup

It is assumed that you already have node and npm installed. If you
do not already have gulp installed, install it globally with npm:

```bash
% npm install --global gulp
```

After the first time you clone, or anytime an npm package is added
or removed from package.json:

```bash
% npm install
```

### Starting server

To start the development server, run:

```bash
% gulp
```

This will watch for changes to the source code and automatically
restart.

## Building

### Developer Build

To build the app in developer mode (no uglification), run:

```bash
% gulp build
```

### Production Build

To build the app in production mode (with uglification), run:

```bash
% gulp production-build
```

## License

Copyright (c) 2015

MIT License
