module.exports = (grunt) ->
	coffee = require 'coffee-script'
	normalizeFilesHelper = require './normalizeFilesHelper'

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		normalized = normalizeFilesHelper @
		groups = normalized.groups
		bare = @.data.bare ? false

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source

				sourceContents.push contents

			separator = grunt.util.linefeed
			contents = sourceContents.join grunt.util.normalizelf separator
			destination = dest.replace '.coffee', '.js'

			try
				compiled = coffee.compile contents, {bare, filename: src}
				grunt.file.write destination, compiled
				grunt.verbose.ok "#{src} -> #{destination}"
			catch e
				grunt.fail.warn "#{src} -> #{destination}"