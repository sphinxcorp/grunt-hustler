module.exports = (grunt) ->
	fs = require 'fs'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	helpers['hustler copy'] = (data) ->
		normalized = helpers['hustler normalizeFiles'] data
		groups = normalized.groups

		for dest, src of groups
			srcCount = src.length

			if srcCount > 1
				contents = helpers.name 'concat', src
			else
				contents = fs.readFileSync src[0]

			grunt.file.write dest, contents
			grunt.verbose.ok "#{src} -> #{dest}"

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		helpers['hustler copy'] @