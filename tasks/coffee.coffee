###global module, require###

module.exports = (grunt) ->
	os = require 'os'
	path = require 'path'
	_ = grunt.utils._

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		done = @async()
		src = @file.src
		dest = @file.dest
		bare = @data.bare ? false
		isWindows = !!process.platform.match /^win/
		cmd = if isWindows then 'cmd' else 'node'
		args = []

		args.push '/c' if isWindows
		args.push path.normalize './node_modules/.bin/coffee'
		args.push '--compile'
		args.push '--bare' if bare
		args.push '--output'
		args.push path.normalize dest
		args.push path.normalize src

		child = grunt.utils.spawn {cmd, args}, (err) ->
			if err
				grunt.log.error err
			else
				grunt.log.write 'coffee success'

			done true

		child.stdout.on 'data', (buffer) ->
			grunt.log.writeln _.rtrim buffer

		child.stderr.on 'data', (buffer) ->
			grunt.log.writeln _.rtrim buffer