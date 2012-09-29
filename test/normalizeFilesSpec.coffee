grunt = require 'grunt'
fs = require 'fs'
createFile = grunt.file.write

temp = './temp/'
from = "#{temp}from/"
to = "#{temp}to/"

module.exports =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	'src': (test) ->
		test.expect 2

		createFile "#{from}a.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		data = {
			data: {
				src: "#{from}a.coffee"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				'temp/from/a.coffee'
			]
		}

		test.deepEqual normalized.groups, groups
		test.done()
	'src array': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				'temp/from/a.coffee',
				'temp/from/b.coffee'
			]
		}

		test.deepEqual normalized.groups, groups
		test.done()
	'src array with file matches': (test) ->
		test.expect 6

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}c.html", ''
		createFile "#{from}d.html", ''
		createFile "#{from}e.txt", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'
		test.equal true, fs.existsSync "#{from}d.html", 'should find d.html'
		test.equal true, fs.existsSync "#{from}e.txt", 'should find e.txt'

		data = {
			data: {
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee",
					"#{from}**/*.html"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				'temp/from/a.coffee',
				'temp/from/b.coffee',
				'temp/from/c.html',
				'temp/from/d.html'
			]
		}

		test.deepEqual normalized.groups, groups
		test.done()
	'src array with file matches and non-existent src': (test) ->
		test.expect 7

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}c.html", ''
		createFile "#{from}d.html", ''
		createFile "#{from}e.txt", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'
		test.equal true, fs.existsSync "#{from}d.html", 'should find d.html'
		test.equal true, fs.existsSync "#{from}e.txt", 'should find e.txt'
		test.equal false, fs.existsSync "#{from}nothere.log", 'should not find nothere.log'

		data = {
			data: {
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee",
					"#{from}**/*.html",
					"#{from}nothere.log"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				'temp/from/a.coffee',
				'temp/from/b.coffee',
				'temp/from/c.html',
				'temp/from/d.html'
			]
		}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src': (test) ->
		test.expect 2

		createFile "#{from}a.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js",
				src: "#{from}a.coffee"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\a.js']
			groups = {
				'temp\\to\\a.js': [
					'temp/from/a.coffee'
				]
			}
		else
			groups = {
				'temp/to/a.js': [
					'temp/from/a.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src with non-existent src': (test) ->
		test.expect 2
		test.equal false, fs.existsSync "#{from}a.coffee", 'should not find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js",
				src: "#{from}a.coffee"
			}
		}

		groups = {}
		normalized = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src with file matches': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js",
				src: "#{from}**/*.coffee"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\min.js']
			groups = {
				'temp\\to\\min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

			# Windows doesn't reliably collect files in alphabetical order
			group = 'temp\\to\\min.js'
			unsorted = normalized.groups[group]
			normalized.groups[group] = unsorted.sort()
		else
			groups = {
				'temp/to/min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src array': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js",
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\min.js']
			groups = {
				'temp\\to\\min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}
		else
			groups = {
				'temp/to/min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src array with file matches': (test) ->
		test.expect 6

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}sub/c.coffee", ''
		createFile "#{from}sub/d.coffee", ''
		createFile "#{from}sub/e.html", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}sub/c.coffee", 'should find sub/c.coffee'
		test.equal true, fs.existsSync "#{from}sub/d.coffee", 'should find sub/d.coffee'
		test.equal true, fs.existsSync "#{from}sub/e.html", 'should find sub/e.html'

		data = {
			data: {
				dest: "#{to}min.js",
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee",
					"#{from}sub/**/*.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\min.js']
			groups = {
				'temp\\to\\min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee',
					'temp/from/sub/c.coffee'
					'temp/from/sub/d.coffee'
				]
			}

			# Windows doesn't reliably collect files in alphabetical order
			group = 'temp\\to\\min.js'
			unsorted = normalized.groups[group]
			normalized.groups[group] = unsorted.sort()
		else
			groups = {
				'temp/to/min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee',
					'temp/from/sub/c.coffee'
					'temp/from/sub/d.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src array with non-existent src': (test) ->
		test.expect 4

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal false, fs.existsSync "#{from}c.coffee", 'should not find c.coffee'

		data = {
			data: {
				dest: "#{to}min.js",
				src: [
					"#{from}a.coffee",
					"#{from}b.coffee"
					"#{from}c.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\min.js']
			groups = {
				'temp\\to\\min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}
		else
			groups = {
				'temp/to/min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src where dest is a directory': (test) ->
		test.expect 7

		createFile "#{from}a.coffee", ''
		createFile "#{from}b/b.coffee", ''
		createFile "#{from}sub/c/c.coffee", ''
		createFile "#{from}sub/d/d.coffee", ''
		createFile "#{from}html/a.html", ''
		createFile "#{from}html/b.html", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b/b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}sub/c/c.coffee", 'should find c.coffee'
		test.equal true, fs.existsSync "#{from}sub/d/d.coffee", 'should find d.coffee'
		test.equal true, fs.existsSync "#{from}html/a.html", 'should find a.html'
		test.equal true, fs.existsSync "#{from}html/b.html", 'should find b.html'

		data = {
			data: {
				dest: "#{to}",
				src: [
					"#{from}a.coffee",
					"#{from}b/b.coffee",
					"#{from}sub/**/*.coffee"
					"#{from}**/*.html"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\a.coffee']
			groups = {
				'temp\\to\\a.coffee': [
					'temp/from/a.coffee'
				],
				'temp\\to\\b.coffee': [
					'temp/from/b/b.coffee'
				],
				'temp\\to\\c\\c.coffee': [
					'temp/from/sub/c/c.coffee'
				],
				'temp\\to\\d\\d.coffee': [
					'temp/from/sub/d/d.coffee'
				],
				'temp\\to\\html\\a.html': [
					'temp/from/html/a.html'
				],
				'temp\\to\\html\\b.html': [
					'temp/from/html/b.html'
				]
			}
		else
			groups = {
				'temp/to/a.coffee': [
					'temp/from/a.coffee'
				],
				'temp/to/b.coffee': [
					'temp/from/b/b.coffee'
				],
				'temp/to/c/c.coffee': [
					'temp/from/sub/c/c.coffee'
				],
				'temp/to/d/d.coffee': [
					'temp/from/sub/d/d.coffee'
				],
				'temp/to/html/a.html': [
					'temp/from/html/a.html'
				],
				'temp/to/html/b.html': [
					'temp/from/html/b.html'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'dest and src where src is a directory': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js",
				src: "#{from}"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\min.js']
			groups = {
				'temp\\to\\min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

			# Windows doesn't reliably collect files in alphabetical order
			group = 'temp\\to\\min.js'
			unsorted = normalized.groups[group]
			normalized.groups[group] = unsorted.sort()
		else
			groups = {
				'temp/to/min.js': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'src where src is a directory': (test) ->
		test.expect 4

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				src: "#{from}"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.dirs['temp\\from\\']
			dirs = {
				'temp\\from\\': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

			# Windows doesn't reliably collect files in alphabetical order
			dir = 'temp\\to\\min.js'
			unsorted = normalized.dirs[dir]
			normalized.dirs[dir] = unsorted.sort()
		else
			dirs = {
				'temp/from/': [
					'temp/from/a.coffee',
					'temp/from/b.coffee'
				]
			}

		groups = {
			'0': [
				'temp/from/a.coffee',
				'temp/from/b.coffee'
			]
		}

		# Windows doesn't reliably collect files in alphabetical order
		group = '0'
		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.deepEqual normalized.dirs, dirs
		test.deepEqual normalized.groups, groups
		test.done()
	'files with source and destination': (test) ->
		test.expect 7

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}sub/c.coffee", ''
		createFile "#{from}sub/d.coffee", ''
		createFile "#{from}sub2/e.coffee", ''
		createFile "#{from}sub2/f.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}sub/c.coffee", 'should find c.coffee'
		test.equal true, fs.existsSync "#{from}sub/d.coffee", 'should find d.coffee'
		test.equal true, fs.existsSync "#{from}sub2/e.coffee", 'should find e.coffee'
		test.equal true, fs.existsSync "#{from}sub2/f.coffee", 'should find f.coffee'

		data = {
			data: {
				files: {
					'./temp/to/a.js': './temp/from/a.coffee',
					'./temp/to/b.js': './temp/from/b.coffee',
					'./temp/to/sub.min.js': './temp/from/sub/**/*.coffee',
					'./temp/to/sub2.min.js': ['./temp/from/sub2/e.coffee', './temp/from/sub2/f.coffee']
				}
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		if normalized.groups['temp\\to\\a.js']
			groups = {
				'temp\\to\\a.js': [
					'temp/from/a.coffee'
				],
				'temp\\to\\b.js': [
					'temp/from/b.coffee'
				],
				'temp\\to\\sub.min.js': [
					'temp/from/sub/c.coffee',
					'temp/from/sub/d.coffee'
				],
				'temp\\to\\sub2.min.js': [
					'temp/from/sub2/e.coffee',
					'temp/from/sub2/f.coffee'
				]
			}

			# Windows doesn't reliably collect files in alphabetical order
			group = 'temp\\to\\sub.min.js'
			unsorted = normalized.groups[group]
			normalized.groups[group] = unsorted.sort()
			group = 'temp\\to\\sub2.min.js'
			unsorted = normalized.groups[group]
			normalized.groups[group] = unsorted.sort()
		else
			groups = {
				'temp/to/a.js': [
					'temp/from/a.coffee'
				],
				'temp/to/b.js': [
					'temp/from/b.coffee'
				],
				'temp/to/sub.min.js': [
					'temp/from/sub/c.coffee',
					'temp/from/sub/d.coffee'
				],
				'temp/to/sub2.min.js': [
					'temp/from/sub2/e.coffee',
					'temp/from/sub2/f.coffee'
				]
			}

		test.deepEqual normalized.groups, groups
		test.done()
	'files with source': (test) ->
		test.expect 7

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}sub/c.coffee", ''
		createFile "#{from}sub/d.coffee", ''
		createFile "#{from}sub2/e.coffee", ''
		createFile "#{from}sub2/f.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}sub/c.coffee", 'should find c.coffee'
		test.equal true, fs.existsSync "#{from}sub/d.coffee", 'should find d.coffee'
		test.equal true, fs.existsSync "#{from}sub2/e.coffee", 'should find e.coffee'
		test.equal true, fs.existsSync "#{from}sub2/f.coffee", 'should find f.coffee'

		data = {
			data: {
				files: [
					'./temp/from/a.coffee',
					'./temp/from/b.coffee',
					'./temp/from/sub/**/*.coffee',
					['./temp/from/sub2/e.coffee', './temp/from/sub2/f.coffee']
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				'temp/from/a.coffee'
			],
			'1': [
				'temp/from/b.coffee'
			],
			'2': [
				'temp/from/sub/c.coffee',
				'temp/from/sub/d.coffee'
			],
			'3': [
				'temp/from/sub2/e.coffee',
				'temp/from/sub2/f.coffee'
			]
		}

		# Windows doesn't reliably collect files in alphabetical order
		group = '2'
		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()
		group = '3'
		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.deepEqual normalized.groups, groups
		test.done()