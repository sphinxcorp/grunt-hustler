###global module, require###

module.exports = (grunt) ->
	grunt.registerMultiTask 'server', 'Run a server', ->
		done = @async()
		src = @file.src
		target = @target
		config = @data
		watch = config.watch
		port = config.port
		cmd = 'node'

		if watch
			args = [
				'node_modules/.bin/nodemon'
				src
				'-w'
				watch
				port
			]
		else
			args = [
				src
				port
			]

		grunt.log.write "starting \"#{target}\" web server at \"http://localhost:#{port}\""

		grunt.utils.spawn {cmd, args}, (err) ->
			if err
				grunt.log.error err
			else
				grunt.log.write 'server success'

			done true