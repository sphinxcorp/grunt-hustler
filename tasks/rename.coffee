###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'

	grunt.registerHelper 'hustler rename', (data) ->
		normalized = grunt.helper 'hustler normalizeFiles', data
		groups = normalized.groups

		for dest, src of groups
			src.forEach (source) ->
				fs.renameSync source, dest
				grunt.verbose.ok "#{source} -> #{dest}"

	grunt.registerMultiTask 'rename', 'Renames files', ->
		grunt.helper 'hustler rename', @