module.exports = (grunt) ->
	renameHelper = require './renameHelper'

	grunt.registerMultiTask 'rename', 'Renames files', ->
		renameHelper @