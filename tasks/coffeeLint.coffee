module.exports = (grunt) ->
	coffeeLint = require 'coffeelint'
	normalizeFilesHelper = require './normalizeFilesHelper'

	grunt.registerMultiTask 'coffeeLint', 'Lints CoffeeScript files', ->
		normalized = normalizeFilesHelper @
		groups = normalized.groups
		data = @data

		for dest, src of groups
			src.forEach (source) ->
				contents = grunt.file.read source
				errors = coffeeLint.lint contents, data

				return if not errors.length
					grunt.verbose.ok source

				grunt.log.header source

				errors.forEach (error) ->
					grunt.log.error "##{error.lineNumber}: #{error.message} (#{error.context})"