module.exports = (grunt) ->
	deleteHelper = require './deleteHelper'

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		deleteHelper @