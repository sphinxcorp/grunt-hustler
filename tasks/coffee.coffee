###global module, require###

module.exports = (grunt) ->
	coffee = require 'coffee-script'

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
			destination = dest.replace '.coffee', '.js'

			try
				compiled = coffee.compile contents, {bare, filename: src}
				grunt.file.write destination, compiled
				grunt.verbose.ok "#{src} -> #{destination}"
			catch e
				grunt.fail.warn "#{src} -> #{destination}"

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		grunt.helper 'hustler coffee', @