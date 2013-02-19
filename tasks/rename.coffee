module.exports = (grunt) ->
	fs = require 'fs'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	helpers['hustler rename'] = (data) ->
		normalized = helpers['hustler normalizeFiles'] data
		groups = normalized.groups

		for dest, src of groups
			src.forEach (source) ->
				fs.renameSync source, dest
				grunt.verbose.ok "#{source} -> #{dest}"

	grunt.registerMultiTask 'rename', 'Renames files', ->
		helpers['hustler rename'] @