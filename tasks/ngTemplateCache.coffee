module.exports = (grunt) ->
	escapeContent = (content) ->
		# escape single quotes
		content = content.replace /'/g, '\\\''

		# add single quotes at the beginning and end of each line
		content = content.replace /\r?\n/g, '\' +\n\''

	prettyDiff = require 'prettydiff'
	linefeed = grunt.util.normalizelf grunt.util.linefeed

	grunt.registerMultiTask 'ngTemplateCache', 'Creates a script file pushing all views into the template cache.', ->
		options = @options(
			module: 'app'
			trim: './.temp'
		)

		grunt.verbose.writeflags options, 'Options'

		@files.forEach (f) ->
			prefix = "angular.module('#{options.module}').run(['$templateCache', function ($templateCache) {"
			suffix = '}]);'

			output = f.src.filter((filePath) ->
				unless grunt.file.exists(filePath)
					grunt.log.warn "Source file \" #{filePath}\" not found."

					false
				else
					true
			).map((filePath) ->
				content = grunt.file.read filePath

				minifyOptions =
					conditional: true
					html: 'html-yes'
					mode: 'minify'
					source: content

				minified = prettyDiff.api(minifyOptions)[0]
				escaped = escapeContent minified
				cache = "\t$templateCache.put('#{filePath.replace(options.trim, '')}', '#{escaped}');"
			)

			output.unshift prefix
			output.push suffix
			grunt.file.write f.dest, output.join linefeed
			grunt.log.writeln "File #{f.dest} created."