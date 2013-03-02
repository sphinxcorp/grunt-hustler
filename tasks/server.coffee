module.exports = (grunt) ->
	grunt.registerMultiTask 'server', 'Run a server', ->
		done = @async()
		data = @data
		src = data.src
		port = data.port
		watch = data.watch
		process.env.PORT = port
		process.argv[2] = src
		process.argv[3] = "--watch #{watch}" if watch

		require 'nodemon'