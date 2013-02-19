module.exports = (grunt) ->
	crypto = require 'crypto'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	helpers['hustler template'] = (config) ->
		normalized = helpers['hustler normalizeFiles'] config
		groups = normalized.groups
		config.data.include = grunt.file.read

		config.data.hash = (filePath) ->
			contents = grunt.file.read filePath
			hash = crypto.createHash('sha1').update(contents).digest('hex').substr(0, 10)

		config.data.uniqueVersion = ->
			uniqueVersion = (new Date()).getTime()

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
		helpers['hustler template'] @