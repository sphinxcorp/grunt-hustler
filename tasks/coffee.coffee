###global module, require###

module.exports = (grunt) ->
	coffeeScript = require 'coffee-script'

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		done = @async()
		src = @file.src
		dest = @file.dest
		bare = @data.bare ? false
		cmd = 'node'

		args = [
			'node_modules/.bin/coffee'
			'--compile'
			'--bare' if bare
			'--output'
			dest
			src
		]

		grunt.utils.spawn {cmd, args}, (err) ->
			if err
				grunt.log.error err
			else
				grunt.log.write 'coffee success'

			done true