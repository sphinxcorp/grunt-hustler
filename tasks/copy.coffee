module.exports = (grunt) ->
	copyHelper = require './copyHelper'

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		copyHelper @