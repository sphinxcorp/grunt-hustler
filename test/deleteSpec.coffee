grunt = require 'grunt'
fs = require 'fs'
createFile = grunt.file.write

temp = './temp/'
from = "#{temp}from/"

exports['directory'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		createFile "#{from}b.js", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 5
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b.js", 'should find b.js'

		grunt.helper 'hustler delete', data: src: from

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b.js", 'should not find b.js'
		test.equal false, fs.existsSync "#{from}", 'should not find directory'
		test.done()

exports['array of directories'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a/a.js", ''
		createFile "#{from}b/b.js", ''
		createFile "#{from}c/d/d.js", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 9
		test.equal true, fs.existsSync "#{from}a/a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b/b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{from}c/d/d.js", 'should find d.js inside d directory'

		src = ["#{from}a/", "#{from}b/", "#{from}c/"]

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a/a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b/b.js", 'should not find b.js'
		test.equal false, fs.existsSync "#{from}c/d/d.js", 'should not find d.js inside d directory'
		test.equal false, fs.existsSync "#{from}a/", 'should not find a directory'
		test.equal false, fs.existsSync "#{from}b/", 'should not find b directory'
		test.equal false, fs.existsSync "#{from}c/", 'should not find c directory'
		test.done()

exports['file'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 2
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'

		src = "#{from}a.js"

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.done()

exports['array of files'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		createFile "#{from}b.js", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 4
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b.js", 'should find b.js'

		src = ["#{from}a.js", "#{from}b.js"]

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b.js", 'should not find b.js'
		test.done()

exports['file match'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		createFile "#{from}b.js", ''
		createFile "#{from}c.html", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 6
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'

		src = "#{from}**/*.js"

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b.js", 'should not find b.js'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'
		test.done()

exports['array of file matches to directory'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		createFile "#{from}b.js", ''
		createFile "#{from}c.html", ''
		createFile "#{from}d.html", ''
		createFile "#{from}e.txt", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 10
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{from}c.html", 'should find c.html'
		test.equal true, fs.existsSync "#{from}d.html", 'should find d.html'
		test.equal true, fs.existsSync "#{from}e.txt", 'should find e.txt'

		src = ["#{from}**/*.js", "#{from}**/*.html"]

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b.js", 'should not find b.js'
		test.equal false, fs.existsSync "#{from}c.html", 'should not find c.html'
		test.equal false, fs.existsSync "#{from}d.html", 'should not find d.html'
		test.equal true, fs.existsSync "#{from}e.txt", 'should find e.txt'
		test.done()

exports['array of files, file matches, and directories'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		createFile "#{from}b.js", ''
		createFile "#{from}c/c.js", ''
		createFile "#{from}d/d.js", ''
		createFile "#{from}e/f/f.js", ''
		createFile "#{from}g.html", ''
		createFile "#{from}h.html", ''
		createFile "#{from}i.txt", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 19
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{from}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{from}c/c.js", 'should find c.js'
		test.equal true, fs.existsSync "#{from}d/d.js", 'should find d.js'
		test.equal true, fs.existsSync "#{from}e/f/f.js", 'should find f/f.js'
		test.equal true, fs.existsSync "#{from}g.html", 'should find g.html'
		test.equal true, fs.existsSync "#{from}h.html", 'should find h.html'
		test.equal true, fs.existsSync "#{from}i.txt", 'should find i.txt'

		src = ["#{from}a.js", "#{from}b.js", "#{from}c/", "#{from}d/", "#{from}e/", "#{from}**/*.html"]

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{from}b.js", 'should not find b.js'
		test.equal false, fs.existsSync "#{from}c/c.js", 'should not find c.js'
		test.equal false, fs.existsSync "#{from}d/d.js", 'should not find d.js'
		test.equal false, fs.existsSync "#{from}e/f/f.js", 'should not find f/f.js'
		test.equal false, fs.existsSync "#{from}g.html", 'should not find g.html'
		test.equal false, fs.existsSync "#{from}h.html", 'should not find h.html'
		test.equal true, fs.existsSync "#{from}i.txt", 'should find i.txt'
		test.equal false, fs.existsSync "#{from}c/", 'should not c directory'
		test.equal false, fs.existsSync "#{from}d/", 'should not d directory'
		test.equal false, fs.existsSync "#{from}e/", 'should not e directory'
		test.done()

exports['file'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.js", ''
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 2
		test.equal true, fs.existsSync "#{from}a.js", 'should find a.js'

		src = "#{from}a.js"

		grunt.helper 'hustler delete', data: src: src

		test.equal false, fs.existsSync "#{from}a.js", 'should not find a.js'
		test.done()