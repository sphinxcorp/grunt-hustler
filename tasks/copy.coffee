module.exports = (grunt) ->
	fs = require 'fs'
	normalizeFilesHelper = require './normalizeFilesHelper'

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		normalized = normalizeFilesHelper @
		groups = normalized.groups

		for dest, src of groups
			srcCount = src.length

			if srcCount > 1
				contents = helpers.name 'concat', src
			else
				contents = fs.readFileSync src[0]

			grunt.file.write dest, contents
			grunt.verbose.ok "#{src} -> #{dest}"