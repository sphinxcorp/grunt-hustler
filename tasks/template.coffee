###global module, require###

module.exports = (grunt) ->
	grunt.registerHelper 'hustler template', (config) ->
		normalized = grunt.helper 'hustler normalizeFiles', config
		groups = normalized.groups
		config.data.include = grunt.file.read

		config.data.uniqueVersion = ->
			uniqueVersion = (new Date()).getTime()

			uniqueVersion

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source

				sourceContents.push contents

			separator = grunt.utils.linefeed
			contents = sourceContents.join grunt.utils.normalizelf separator
			compiled = grunt.template.process contents, config: config.data
			destination = dest.replace '.template', '.html'

			grunt.file.write destination, compiled
			grunt.verbose.ok "#{src} -> #{destination}"

	grunt.registerMultiTask 'template', 'Compiles templates', ->
		grunt.helper 'hustler template', @