###global module, require###

module.exports = (grunt) ->
	coffee = require 'coffee-script'
	path = require 'path'

	grunt.registerHelper 'hustler coffee', (config) ->
		normalized = grunt.helper 'hustler normalizeFiles', config
		groups = normalized.groups
		bare = config.data.bare ? false

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source

				sourceContents.push contents

			separator = grunt.utils.linefeed
			contents = sourceContents.join grunt.utils.normalizelf separator
			compiled = coffee.compile contents, {bare}
			destination = dest.replace '.coffee', '.js'

			grunt.file.write destination, compiled
			grunt.verbose.ok "#{src} -> #{destination}"

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		grunt.helper 'hustler coffee', @