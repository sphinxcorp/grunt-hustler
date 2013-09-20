[![build status](https://secure.travis-ci.org/CaryLandholt/grunt-hustler.png)](http://travis-ci.org/CaryLandholt/grunt-hustler)
[![NPM version](https://badge.fury.io/js/grunt-hustler.png)](http://badge.fury.io/js/grunt-hustler)
[![dependency status](https://david-dm.org/CaryLandholt/grunt-hustler.png)](https://david-dm.org/CaryLandholt/grunt-hustler)
# grunt-hustler

## Contents

* [What is grunt-hustler?](#what-is-grunt-hustler)
* [Installation](#installation)
* [Usage](#usage)
* [Bust](#bust)
* [Hash](#hash)
* [MinifyHtml](#minifyhtml)
* [ngTemplateCache](#ngTemplateCache)
* [Versioning](#versioning)
* [Bug Tracker](#bug-tracker)
* [Author](#author)
* [License](#license)

## What is grunt-hustler?

A collection of [grunt](https://github.com/cowboy/grunt) tasks.

* hash - renames files based on their hashed contents
* minifyHtml - minifies html views (not using grunt-contrib until their minifier supports valueless attributes and xml namespaces)
* shimmer - creates a RequireJS main file
* ngTemplateCache - creates a JavaScript file, placing all views in the AngularJS $templateCache
* template - compiles views containing Lo-Dash template commands.

## Installation

```bash
$ npm install grunt-hustler
```

## Usage

Include the following line in your Grunt file.

```bash
grunt.loadNpmTasks('grunt-hustler');
```

## Bust
Bust provides cache busting by renaming files with a hash based on their contents. It also replaces all instances of the file references.

Example Config:
```javascript
_grunt.config('bust', {
  images: {
    files: [
      {
        cwd: '/temp/',
        src: ['images/**/*.png'],
        dest: '/temp/',
        replaceIn: {
          files: ['/temp/styles/styles.css']
        }
      }
    ]
  }
});
```
## Hash
Renames files based on the hash of their contents.

scripts.min.js -> scripts.min.abse455dcd.js

Example Config:
```javascript
_grunt.config('hash', {
  scripts: {
    files: [
      {
        cwd: '/temp/',
        src: ['scripts/scripts.min.js'],
        dest: '/temp/scripts/'
      }
    ]
  }
});
```

## MinifyHtml
Minifies Html

Example Config:
```javascript
_grunt.config('minifyHtml', {
  scripts: {
    files: [
      {
        src: 'index.html',
        dest: '/scripts/'
      }
    ]
  }
});
```

## ngTemplateCache
Creates a script file pushing all views from html files into Angular's template cache.

Example Config:
```javascript
_grunt.config('ngTemplateCache', {
  views: {
    files: [
      {
        './scripts/views.js': './views/**/*.html'
      }
    ]
  }
});
```

Options:
Trim option allows to remove directory name from before adding the path to the ngTemplateCache's registry. If you are working in a temporary directory working directory while running the grunt task, this is particularly helpful.
```javascript
options: {
  trim: '/temp'
}
```


## Versioning

For transparency and insight into our release cycle, and for striving to maintain backwards compatibility, this module will be maintained under the Semantic Versioning guidelines as much as possible.

Releases will be numbered with the follow format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backwards compatibility bumps the major
* New additions without breaking backwards compatibility bumps the minor
* Bug fixes and misc changes bump the patch

For more information on SemVer, please visit http://semver.org/.

## Bug tracker

Have a bug?  Please create an issue here on GitHub!

https://github.com/CaryLandholt/grunt-hustler/issues

## Author

**Cary Landholt**

+ http://twitter.com/CaryLandholt
+ http://github.com/CaryLandholt


## License

Copyright 2013 Cary Landholt

Licensed under the MIT license.
