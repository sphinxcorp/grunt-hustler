###global module, require###

module.exports = (grunt) ->
	prettyDiff = require 'prettydiff'

	grunt.registerHelper 'hustler minifyHtml', (config) ->
		normalized = grunt.helper 'hustler normalizeFiles', config
		groups = normalized.groups

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source

				sourceContents.push contents

			separator = grunt.utils.linefeed
			contents = sourceContents.join grunt.utils.normalizelf separator

			options =
				source: contents
				mode: 'minify'
				diff: ''

			compiled = prettyDiff.api(options)[0]
			destination = dest.replace '.html', '.min.html'

			grunt.file.write destination, compiled
			grunt.verbose.ok "#{src} -> #{destination}"

	grunt.registerMultiTask 'minifyHtml', 'Minifies Html', ->
		grunt.helper 'hustler minifyHtml', @