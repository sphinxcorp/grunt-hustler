###global module, require###

module.exports = (grunt) ->
	grunt.registerHelper 'hustler copy', (data) ->
		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = normalized.groups

		for dest, src of groups
			contents = grunt.helper 'concat', src

			grunt.file.write dest, contents
			grunt.verbose.ok "#{src} -> #{dest}"

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		grunt.helper 'hustler copy', @