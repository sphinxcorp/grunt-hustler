grunt = require 'grunt'
fs = require 'fs'
createFile = grunt.file.write
readFile = grunt.file.read

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
	'coffee to js': (test) ->
		test.expect 6

		createFile "#{from}a.coffee", 'a = 1'
		createFile "#{from}b.coffee", 'b = 2'

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		grunt.helper 'hustler coffee', data: src: from, dest: to

		aExpect = '(function() {\n  var a;\n\n  a = 1;\n\n}).call(this);\n'
		aContents = readFile "#{to}a.js"
		bExpect = '(function() {\n  var b;\n\n  b = 2;\n\n}).call(this);\n'
		bContents = readFile "#{to}b.js"

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.equal aExpect, aContents, 'a.js should be compiled coffee'
		test.equal bExpect, bContents, 'b.js should be compiled coffee'
		test.done()
	'coffee to js with bare': (test) ->
		test.expect 6

		createFile "#{from}a.coffee", 'a = 1'
		createFile "#{from}b.coffee", 'b = 2'

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		grunt.helper 'hustler coffee', data: src: from, dest: to, bare: true

		aExpect = 'var a;\n\na = 1;\n'
		aContents = readFile "#{to}a.js"
		bExpect = 'var b;\n\nb = 2;\n'
		bContents = readFile "#{to}b.js"

		test.equal true, fs.existsSync "#{to}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{to}b.js", 'should find b.js'
		test.equal aExpect, aContents, 'a.js should be compiled coffee'
		test.equal bExpect, bContents, 'b.js should be compiled coffee'
		test.done()
	'coffee to js concatenated': (test) ->
		test.expect 5

		createFile "#{from}a.coffee", 'a = 1'
		createFile "#{from}b.coffee", 'b = 2'

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		dest = "#{to}min.js"

		grunt.helper 'hustler coffee', data: src: from, dest: dest, bare: true

		expect = 'var a, b;\n\na = 1;\n\nb = 2;\n'
		contents = readFile dest

		test.equal false, fs.existsSync "#{to}a.js", 'should not find a.js'
		test.equal false, fs.existsSync "#{to}b.js", 'should not find b.js'
		test.equal expect, contents, 'min.js should be compiled coffee'
		test.done()