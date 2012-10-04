###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'

	grunt.registerHelper 'hustler copy', (data) ->
		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = normalized.groups

		for dest, src of groups
			srcCount = src.length

			if srcCount > 1
				contents = grunt.helper 'concat', src
			else
				contents = fs.readFileSync src[0]

			grunt.file.write dest, contents
			grunt.verbose.ok "#{src} -> #{dest}"

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		grunt.helper 'hustler copy', @