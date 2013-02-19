module.exports = (grunt) ->
	coffeeLint = require 'coffeelint'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	helpers['hustler coffeeLint'] = (data) ->
		normalized = helpers['hustler normalizeFiles'] data
		groups = normalized.groups

		for dest, src of groups
			src.forEach (source) ->
				contents = grunt.file.read source
				errors = coffeeLint.lint contents, data.data

				return if not errors.length
					grunt.verbose.ok source

				grunt.log.header source

				errors.forEach (error) ->
					grunt.log.error "##{error.lineNumber}: #{error.message} (#{error.context})"

	grunt.registerMultiTask 'coffeeLint', 'Lints CoffeeScript files', ->
		helpers['hustler coffeeLint'] @