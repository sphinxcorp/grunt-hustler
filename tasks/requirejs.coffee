module.exports = (grunt) ->
	requirejs = require 'requirejs'

	grunt.registerMultiTask 'requirejs', 'Runs the RequireJS Optimizer', ->
		done = @async()
		config = @data

		requirejs.optimize config, (buildResponse) ->
			grunt.verbose.writeln buildResponse
			done()