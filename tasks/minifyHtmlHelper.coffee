module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	prettyDiff = require 'prettydiff'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	groups = normalized.groups
	data = config.data
	conditional = data.conditional ? true

	for dest, src of groups
		sourceContents = []

		src.forEach (source) ->
			contents = grunt.file.read source

			sourceContents.push contents

		separator = grunt.util.linefeed
		contents = sourceContents.join grunt.util.normalizelf separator

		options =
			source: contents
			mode: 'minify'
			conditional: conditional
			html: 'html-yes'

		compiled = prettyDiff.api(options)[0]

		grunt.file.write dest, compiled
		grunt.verbose.ok "#{src} -> #{dest}"