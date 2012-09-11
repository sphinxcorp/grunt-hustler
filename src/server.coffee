###global module, require###

###global module, require###

module.exports = (grunt) ->
	os = require 'os'
	path = require 'path'
	_ = grunt.utils._

	grunt.registerMultiTask 'server', 'Run a server', ->
		done = @async()
		src = @file.src
		target = @target
		config = @data
		watch = config.watch
		port = config.port
		isWindows = !!process.platform.match /^win/
		cmd = if isWindows then 'cmd' else 'node'
		args = []

		args.push '/c' if isWindows
		args.push if watch then path.normalize './node_modules/.bin/nodemon' else 'node'
		args.push path.normalize src
		args.push '-w' if watch
		args.push path.normalize watch if watch
		args.push port

		child = grunt.utils.spawn {cmd, args}, (err) ->
			if err
				grunt.log.error err

			done true

		child.stdout.on 'data', (buffer) ->
			grunt.log.writeln _.rtrim buffer

		child.stderr.on 'data', (buffer) ->
			grunt.log.writeln _.rtrim buffer