grunt = require 'grunt'
rimraf = require 'rimraf'
fs = require 'fs'
createFile = grunt.file.write
deleteDirectory = rimraf.sync

temp = './temp/'
from = "#{temp}from/"
to = "#{temp}to/"

exports['dest and src'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 2
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js",
				src: "#{from}a.coffee"
			}
		}

		groups = {
			'temp/to/a.js': [
				'temp/from/a.coffee'
			]
		}

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src with non-existent src'] =
	setUp: (callback) ->
		deleteDirectory temp
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 2
		test.equal false, fs.existsSync "#{from}a.coffee", 'should not find a.coffee'

		data = {
			data: {
				dest: "#{to}a.js",
				src: "#{from}a.coffee"
			}
		}

		groups = {}
		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src with file matches'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 3
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		data = {
			data: {
				dest: "#{to}min.js",
				src: "#{from}**/*.coffee"
			}
		}

		groups = {
			'temp/to/min.js': [
				'temp/from/a.coffee',
				'temp/from/b.coffee'
			]
		}

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src array'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 3
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

		groups = {
			'temp/to/min.js': [
				'temp/from/a.coffee',
				'temp/from/b.coffee'
			]
		}

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src array with file matches'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}sub/c.coffee", ''
		createFile "#{from}sub/d.coffee", ''
		createFile "#{from}sub/e.html", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 6
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

		groups = {
			'temp/to/min.js': [
				'temp/from/a.coffee',
				'temp/from/b.coffee',
				'temp/from/sub/c.coffee'
				'temp/from/sub/d.coffee'
			]
		}

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src array with non-existent src'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 4
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

		groups = {
			'temp/to/min.js': [
				'temp/from/a.coffee',
				'temp/from/b.coffee'
			]
		}

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

exports['dest and src where dest is a directory'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b/b.coffee", ''
		createFile "#{from}sub/c/c.coffee", ''
		createFile "#{from}sub/d/d.coffee", ''
		createFile "#{from}html/a.html", ''
		createFile "#{from}html/b.html", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 7
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

		options = grunt.helper 'hustler normalizeFiles', data

		test.deepEqual options, groups
		test.done()

# exports['files'] =
# 	setUp: (callback) ->
# 		deleteDirectory temp
# 		createFile "#{from}a.coffee", ''
# 		callback()
# 	tearDown: (callback) ->
# 		deleteDirectory temp
# 		callback()
# 	main: (test) ->
# 		test.expect 2
# 		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

# 		data = {
# 			data: {
# 				files: {
# 					'./temp/to/a.js': './temp/from/a.js'
# 				}
# 			}
# 		}

# 		groups = {
# 			'temp/to/a.js': [
# 				'temp/from/a.coffee'
# 			]
# 		}

# 		options = grunt.helper 'hustler normalizeFiles', data

# 		test.deepEqual options, groups
# 		test.done()