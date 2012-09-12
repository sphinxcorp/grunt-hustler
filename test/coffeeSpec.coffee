grunt = require 'grunt'
rimraf = require 'rimraf'
fs = require 'fs'
createFile = grunt.file.write
deleteDirectory = rimraf.sync

temp = './temp/'
from = "#{temp}from/"
to = "#{temp}to/"

exports['directory to directory'] =
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

		grunt.helper 'hustler coffee', from, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.done()

exports['array of directories to directory'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a/a.coffee", ''
		createFile "#{from}b/b.coffee", ''
		createFile "#{from}c/d/d.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 6
		test.equal true, fs.existsSync "#{from}a/a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b/b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c/d/d.coffee", 'should find d.coffee inside d directory'

		src = ["#{from}a/", "#{from}b/", "#{from}c/"]

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{to}d/d.js", 'should find d.js inside d directory'
		test.done()

exports['file to directory'] =
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

		src = "#{from}a.coffee"

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.done()

exports['array of files to directory'] =
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

		src = ["#{from}a.coffee", "#{from}b.coffee"]

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.done()

exports['file match to directory'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}c.html", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 6
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'

		src = "#{from}**/*.coffee"

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.equal false, fs.existsSync "#{to}c.html", 'should not find c.html'
		test.done()

exports['array of file matches to directory'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a/a/a.coffee", ''
		createFile "#{from}b/b/b.coffee", ''
		createFile "#{from}c/c/c.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 6
		test.equal true, fs.existsSync "#{from}a/a/a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b/b/b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c/c/c.coffee", 'should find c.coffee'

		src = ["#{from}a/**/*.coffee", "#{from}c/**/*.coffee"]

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a/a.js", 'should find a.js'
		test.equal false, fs.existsSync "#{to}b/b.js", 'should not find b.js'
		test.equal true, fs.existsSync "#{to}c/c.js", 'should find c.js'
		test.done()

exports['array of files, file matches, and directories to directory'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		createFile "#{from}b.coffee", ''
		createFile "#{from}c/c.coffee", ''
		createFile "#{from}d/d.coffee", ''
		createFile "#{from}a/a/a.coffee", ''
		createFile "#{from}b/b/b.coffee", ''
		createFile "#{from}c/c/c.coffee", ''
		callback()
	tearDown: (callback) ->
		#deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 15
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c/c.coffee", 'should find c.coffee'
		test.equal true, fs.existsSync "#{from}d/d.coffee", 'should find d.coffee'
		test.equal true, fs.existsSync "#{from}a/a/a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b/b/b.coffee", 'should find b.coffee'
		test.equal true, fs.existsSync "#{from}c/c/c.coffee", 'should find c.coffee'

		src = ["#{from}a.coffee", "#{from}b.coffee", "#{from}c/", "#{from}d/", "#{from}a/", "#{from}c/**/*.coffee"]

		grunt.helper 'hustler coffee', src, to

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{to}c.js", 'should find c.js'
		test.equal true, fs.existsSync "#{to}d.js", 'should find d.js'
		test.equal true, fs.existsSync "#{to}a/a.js", 'should find a.js'
		test.equal false, fs.existsSync "#{to}b/", 'should not find b directory'
		test.equal false, fs.existsSync "#{to}b/b.js", 'should not find b.js'
		test.equal true, fs.existsSync "#{to}c/c.js", 'should find c.js'
		test.done()

exports['file to file'] =
	setUp: (callback) ->
		deleteDirectory temp
		createFile "#{from}a.coffee", ''
		callback()
	tearDown: (callback) ->
		deleteDirectory temp
		callback()
	main: (test) ->
		test.expect 4
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		src = "#{from}a.coffee"
		dest = "#{to}b.javascript"

		grunt.helper 'hustler coffee', src, dest

		test.equal false, fs.existsSync "#{to}a.coffee", 'should not find a.coffee'
		test.equal false, fs.existsSync "#{to}a.js", 'should not find a.js'
		test.equal true, fs.existsSync "#{to}b.javascript", 'should find b.javascript'
		test.done()