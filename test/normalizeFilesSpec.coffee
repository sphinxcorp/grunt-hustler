grunt = require 'grunt'
fs = require 'fs'
path = require 'path'
{equalArrayItems, equalGroups} = require './helper/equals'
createFile = grunt.file.write

temp = './temp/'
id = path.basename module.id, '.js'
spec = -1
from = "#{temp}from/"
to = "#{temp}to/"

updatePath = ->
	spec += 1
	base = "#{temp}#{id}/spec#{spec}/"
	from = "#{base}from/"
	to = "#{base}to/"

norm = (p, fixSlashes = true) ->
	normed = path.normalize(p)

	if fixSlashes
		normed.split('\\').join('/')
	else
		normed

module.exports =
	setUp: (callback) ->
		updatePath()
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
				norm "#{from}a.coffee"
			]
		}

		test.ok equalGroups normalized.groups, groups
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
					"#{from}a.coffee"
					"#{from}b.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				norm "#{from}a.coffee"
				norm "#{from}b.coffee"
			]
		}

		test.ok equalGroups normalized.groups, groups
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
					"#{from}a.coffee"
					"#{from}b.coffee"
					"#{from}**/*.html"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				norm "#{from}a.coffee"
				norm "#{from}b.coffee"
				norm "#{from}c.html"
				norm "#{from}d.html"
			]
		}

		test.ok equalGroups normalized.groups, groups
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
					"#{from}a.coffee"
					"#{from}b.coffee"
					"#{from}**/*.html"
					"#{from}nothere.log"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				norm "#{from}a.coffee"
				norm "#{from}b.coffee"
				norm "#{from}c.html"
				norm "#{from}d.html"
			]
		}

		test.ok equalGroups normalized.groups, groups
		test.done()
	'dest and src': (test) ->
		test.expect 2

		createFile "#{from}a.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js"
				src: "#{from}a.coffee"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}

		groups[norm("#{to}a.js", false)] = [
			norm "#{from}a.coffee"
		]

		test.ok equalGroups normalized.groups, groups
		test.done()
	'dest and src with non-existent src': (test) ->
		test.expect 2
		test.equal false, fs.existsSync "#{from}a.coffee", 'should not find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js"
				src: "#{from}a.coffee"
			}
		}

		groups = {}
		normalized = grunt.helper 'hustler normalizeFiles', data

		test.ok equalGroups normalized.groups, groups
		test.done()
	'dest and src with file matches': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js"
				src: "#{from}**/*.coffee"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}
		group = norm "#{to}min.js", false

		groups[group] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.ok equalGroups normalized.groups, groups
		test.done()
	'dest and src array': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js"
				src: [
					"#{from}a.coffee"
					"#{from}b.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}

		groups[norm("#{to}min.js", false)] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		test.ok equalGroups normalized.groups, groups
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
				dest: "#{to}min.js"
				src: [
					"#{from}a.coffee"
					"#{from}b.coffee"
					"#{from}sub/**/*.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}
		group = norm "#{to}min.js", false

		groups[group] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
			norm "#{from}sub/c.coffee"
			norm "#{from}sub/d.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.ok equalGroups normalized.groups, groups
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
				dest: "#{to}min.js"
				src: [
					"#{from}a.coffee"
					"#{from}b.coffee"
					"#{from}c.coffee"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}

		groups[norm("#{to}min.js", false)] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		test.ok equalGroups normalized.groups, groups
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
				dest: "#{to}"
				src: [
					"#{from}a.coffee"
					"#{from}b/b.coffee"
					"#{from}sub/**/*.coffee"
					"#{from}**/*.html"
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}

		groups[norm("#{to}a.coffee", false)] = [
			norm "#{from}a.coffee"
		]

		groups[norm("#{to}b.coffee", false)] = [
			norm "#{from}b/b.coffee"
		]

		groups[norm("#{to}c/c.coffee", false)] = [
			norm "#{from}sub/c/c.coffee"
		]

		groups[norm("#{to}d/d.coffee", false)] = [
			norm "#{from}sub/d/d.coffee"
		]

		groups[norm("#{to}html/a.html", false)] = [
			norm "#{from}html/a.html"
		]

		groups[norm("#{to}html/b.html", false)] = [
			norm "#{from}html/b.html"
		]

		test.ok equalGroups normalized.groups, groups
		test.done()
	'dest and src where src is a directory': (test) ->
		test.expect 3

		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js"
				src: "#{from}"
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}
		group = norm "#{to}min.js", false

		groups[group] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.ok equalGroups normalized.groups, groups
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
		dirs = {}
		dir = norm "#{from}", false

		dirs[dir] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		unsorted = normalized.dirs[dir]
		normalized.dirs[dir] = unsorted.sort()

		groups = {}
		group = '0'

		groups[group] = [
			norm "#{from}a.coffee"
			norm "#{from}b.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.deepEqual normalized.dirs, dirs
		test.ok equalGroups normalized.groups, groups
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

		files = {}
		files[norm("#{to}a.js", false)] = norm "#{from}a.coffee"
		files[norm("#{to}b.js", false)] = norm "#{from}b.coffee"
		files[norm("#{to}sub.min.js", false)] = norm "#{from}sub/**/*.coffee"

		files[norm("#{to}sub2.min.js", false)] = [
			norm "#{from}sub2/e.coffee"
			norm "#{from}sub2/f.coffee"
		]

		data = {
			data: {
				files
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = {}

		groups[norm("#{to}a.js", false)] = [
			norm "#{from}a.coffee"
		]

		groups[norm("#{to}b.js", false)] = [
			norm "#{from}b.coffee"
		]

		group = norm("#{to}sub.min.js", false)

		groups[group] = [
			norm "#{from}sub/c.coffee"
			norm "#{from}sub/d.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		group = norm "#{to}sub2.min.js", false

		groups[group] = [
			norm "#{from}sub2/e.coffee"
			norm "#{from}sub2/f.coffee"
		]

		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.ok equalGroups normalized.groups, groups
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
					norm "#{from}a.coffee"
					norm "#{from}b.coffee"
					norm "#{from}sub/**/*.coffee"
					[
						norm "#{from}sub2/e.coffee"
						norm "#{from}sub2/f.coffee"
					]
				]
			}
		}

		normalized = grunt.helper 'hustler normalizeFiles', data

		groups = {
			'0': [
				norm "#{from}a.coffee"
			]
			'1': [
				norm "#{from}b.coffee"
			]
			'2': [
				norm "#{from}sub/c.coffee"
				norm "#{from}sub/d.coffee"
			]
			'3': [
				norm "#{from}sub2/e.coffee"
				norm "#{from}sub2/f.coffee"
			]
		}

		group = '2'
		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		group = '3'
		unsorted = normalized.groups[group]
		normalized.groups[group] = unsorted.sort()

		test.ok equalGroups normalized.groups, groups
		test.done()