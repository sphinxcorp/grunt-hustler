grunt = require 'grunt'
fs = require 'fs'
path = require 'path'
createFile = grunt.file.write
readFile = grunt.file.read

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

module.exports =
	setUp: (callback) ->
		updatePath()
		callback()
	'file': (test) ->
		test.expect 4

		createFile "#{from}a.coffee", 'a = 1'

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
	'files': (test) ->
		test.expect 8

		createFile "#{from}a.coffee", 'a = 1'
		createFile "#{from}b.coffee", 'b = 2'

		test.equal true, fs.existsSync "#{from}a.coffee", 'should find a.coffee'
		test.equal true, fs.existsSync "#{from}b.coffee", 'should find b.coffee'

		files = {}
		files["#{from}a.renamed"] = "#{from}a.coffee"
		files["#{from}b.renamed"] = "#{from}b.coffee"

		grunt.helper 'hustler rename', data: files: files

		aExpect = 'a = 1'
		aContents = readFile "#{from}a.renamed"
		bExpect = 'b = 2'
		bContents = readFile "#{from}b.renamed"

		test.equal false, fs.existsSync "#{from}a.coffee", 'should not find a.coffee'
		test.equal true, fs.existsSync "#{from}a.renamed", 'should find a.renamed'
		test.equal aExpect, aContents, 'a.renamed contents should be same as original'
		test.equal false, fs.existsSync "#{from}b.coffee", 'should not find b.coffee'
		test.equal true, fs.existsSync "#{from}b.renamed", 'should find b.renamed'
		test.equal bExpect, bContents, 'b.renamed contents should be same as original'
		test.done()