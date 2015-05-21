# Jitterbug

Jitterbug is a game inspired by an old Java homework assignment
that we had in college.

## Running in developer mode

### Setup

After the first time you clone, or anytime an npm package is added
or removed from package.json:

```bash
% npm install
```

After the first time you clone, or anytime a bower package is added
or removed from bower.json:

```bash
% gulp full-bulid
```

### Starting server

To start the development server, run:

```bash
% gulp start
```

This will watch for changes to the source code and automatically
restart. If you change an installed bower package, run ```gulp
full-build```, otherwise simply let ```gulp start``` take care of
everything for you.

# License

Copyright (c) 2015

MIT License
