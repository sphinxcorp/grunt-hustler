###global module, require###

module.exports = (grunt) ->
	grunt.registerMultiTask 'server', 'Run a server', ->
		done = @async()
		src = @file.src
		config = @data
		port = config.port
		watch = config.watch
		process.env.PORT = port
		process.argv[2] = src
		process.argv[3] = "--watch #{watch}" if watch

		require 'nodemon'