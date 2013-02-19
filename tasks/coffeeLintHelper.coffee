module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	coffeeLint = require 'coffeelint'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	groups = normalized.groups

	for dest, src of groups
		src.forEach (source) ->
			contents = grunt.file.read source
			errors = coffeeLint.lint contents, config.data

			return if not errors.length
				grunt.verbose.ok source

			grunt.log.header source

			errors.forEach (error) ->
				grunt.log.error "##{error.lineNumber}: #{error.message} (#{error.context})"