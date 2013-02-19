module.exports = (grunt) ->
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	wrapScript = (contents, type, id, trim) ->
		id = id.replace(trim, '') if trim
		script = "<script type=\"#{type}\" id=\"#{id}\">#{contents}</script>"

		script

	helpers['hustler inlineTemplate'] = (config) ->
		normalized = helpers['hustler normalizeFiles'] config
		groups = normalized.groups
		type = config.data.type
		trim = config.data.trim

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source
				script = wrapScript contents, type, source, trim

				sourceContents.push script

			separator = grunt.utils.linefeed
			contents = sourceContents.join grunt.utils.normalizelf separator

			grunt.file.write dest, contents
			grunt.verbose.ok "#{src} -> #{dest}"

	grunt.registerMultiTask 'inlineTemplate', 'Inlines templates', ->
		helpers['hustler inlineTemplate'] @