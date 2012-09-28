grunt = require 'grunt'
fs = require 'fs'
createFile = grunt.file.write
readFile = grunt.file.read

temp = './temp/'
from = "#{temp}from/"
to = "#{temp}to/"

exports['file'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.coffee", 'a = 1'
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 4
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'

		src = "#{from}a.coffee"
		dest = "#{from}renamed.coffee"

		grunt.helper 'hustler rename', data: src: src, dest: dest

		expect = 'a = 1'
		contents = readFile dest

		test.equal false, fs.existsSync src, 'should not find a.coffee'
		test.equal true, fs.existsSync dest, 'should find renamed.coffee'
		test.equal expect, contents, 'renamed.coffee contents should be same as original'
		test.done()

exports['files'] =
	setUp: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		createFile "#{from}a.coffee", 'a = 1'
		createFile "#{from}b.coffee", 'b = 2'
		callback()
	tearDown: (callback) ->
		grunt.helper 'hustler delete', data: src: temp
		callback()
	main: (test) ->
		test.expect 8
		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		files = {
			'./temp/from/a.renamed': './temp/from/a.coffee',
			'./temp/from/b.renamed': './temp/from/b.coffee'
		}

		grunt.helper 'hustler rename', data: files: files

		aExpect = 'a = 1'
		aContents = readFile './temp/from/a.renamed'
		bExpect = 'b = 2'
		bContents = readFile './temp/from/b.renamed'

		test.equal false, fs.existsSync './temp/from/a.coffee', 'should not find a.coffee'
		test.equal true, fs.existsSync './temp/from/a.renamed', 'should find a.renamed'
		test.equal aExpect, aContents, 'a.renamed contents should be same as original'
		test.equal false, fs.existsSync './temp/from/b.coffee', 'should not find b.coffee'
		test.equal true, fs.existsSync './temp/from/b.renamed', 'should find b.renamed'
		test.equal bExpect, bContents, 'b.renamed contents should be same as original'
		test.done()