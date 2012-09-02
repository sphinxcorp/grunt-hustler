[![build status](https://secure.travis-ci.org/CaryLandholt/grunt-hustler.png)](http://travis-ci.org/CaryLandholt/grunt-hustler)
# grunt-hustler

A collection of [grunt](https://github.com/cowboy/grunt) tasks.

* [coffee](#coffee) - Compile [CoffeeScript](http://coffeescript.org/) (.coffee) to JavaScript (.js)
* [coffeeLint](#coffeeLint) - Lint CoffeeScript files using [coffeelint](http://www.coffeelint.org/)
* copy
* delete
* hash
* requirejs
* server
* template

## Installation

```
npm install grunt-hustler
```

## Usage

Include the following line in your Grunt file.

``` javascript
grunt.loadNpmTasks('grunt-hustler');
```

## Tasks

### coffee

Compile [CoffeeScript](http://coffeescript.org/) (*.coffee) to JavaScript (*.js)

#### options

* src - source directory
* dest - destination directory
* bare - compile the JavaScript without the [top-level function safety wrapper](http://coffeescript.org/#lexical_scope)

#### Example

``` javascript
// example
module.exports = function (grunt) {
	grunt.initConfig({

		/*
		The following will compile all .coffee files in the src directory
		and place the corresponding .js files in the dest directory.
		The directory hierarchy will be maintained.
		*/
		coffee: {
			dist: {
				src: '/src/scripts/',
				dest: '/dist/scripts/',
				bare: true
			}
		}

	});

	grunt.loadNpmTasks('grunt-hustler');
};
```

### coffeeLint

Lint CoffeeScript files using [coffeelint](http://www.coffeelint.org/)

#### options

* see [coffeelint](http://www.coffeelint.org/#options) for options

#### Example

``` javascript
// example
module.exports = function (grunt) {
	grunt.initConfig({

		/*
		The following will lint all .coffee files in the src directory
		with indentation of one tab and no maximum line length
		*/
		coffeeLint: {
			scripts: {
				src: '/src/scripts/**/*.coffee',
				indentation: {
					value: 1
				},
				max_line_length: {
					level: 'ignore'
				},
				no_tabs: {
					level: 'ignore'
				}
			}
		}

	});

	grunt.loadNpmTasks('grunt-hustler');
};
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

Copyright 2012 Cary Landholt

Licensed under the MIT license.