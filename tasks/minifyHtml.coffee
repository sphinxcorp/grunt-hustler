module.exports = (grunt) ->
	prettyDiff = require 'prettydiff'

	grunt.registerMultiTask 'minifyHtml', 'Minifies Html', ->
		options = @options {
			conditional: true
			html: 'html-yes'
			mode: 'minify'
		}

		@files.forEach (filePair) ->
			filePair.src.filter (filePath) ->
				unless grunt.file.exists filePath
					grunt.log.warn "Source file \" #{filePath}\" not found."

					false
				else
					true
			.map (filePath) ->
				contents = grunt.file.read filePath
				options.source = contents
				compiled = prettyDiff.api(options)[0]

				grunt.file.write filePair.dest, compiled
				grunt.verbose.ok "#{filePath} -> #{filePair.dest}"