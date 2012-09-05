###global module, require###

module.exports = (grunt) ->
	coffeeLint = require 'coffeelint'

	grunt.registerMultiTask 'coffeeLint', 'Lints CoffeeScript files', ->
		src = @file.src
		config = @data
		files = grunt.file.expandFiles src

		files.forEach (file, index) ->
			source = grunt.file.read file
			errors = coffeeLint.lint source, config

			if not errors.length
				grunt.log.ok file

				return

			grunt.log.header file

			errors.forEach (error) ->
				grunt.log.error "##{error.lineNumber}: #{error.message} (#{error.context})"