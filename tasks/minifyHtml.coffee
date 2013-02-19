module.exports = (grunt) ->
	prettyDiff = require 'prettydiff'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	helpers['hustler minifyHtml'] = (config) ->
		normalized = helpers['hustler normalizeFiles'] config
		groups = normalized.groups
		data = config.data
		conditional = data.conditional ? true

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
				conditional: conditional
				html: 'html-yes'

			compiled = prettyDiff.api(options)[0]

			grunt.file.write dest, compiled
			grunt.verbose.ok "#{src} -> #{dest}"

	grunt.registerMultiTask 'minifyHtml', 'Minifies Html', ->
		helpers['hustler minifyHtml'] @