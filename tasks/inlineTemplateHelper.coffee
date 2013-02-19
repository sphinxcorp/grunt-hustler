module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	groups = normalized.groups
	type = config.data.type
	trim = config.data.trim

	wrapScript = (contents, type, id, trim) ->
		id = id.replace(trim, '') if trim
		script = "<script type=\"#{type}\" id=\"#{id}\">#{contents}</script>"

		script

	for dest, src of groups
		sourceContents = []

		src.forEach (source) ->
			contents = grunt.file.read source
			script = wrapScript contents, type, source, trim

			sourceContents.push script

		separator = grunt.util.linefeed
		contents = sourceContents.join grunt.util.normalizelf separator

		grunt.file.write dest, contents
		grunt.verbose.ok "#{src} -> #{dest}"