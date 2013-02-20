module.exports = (grunt) ->
	templateHelper = require './templateHelper'

	grunt.registerMultiTask 'template', 'Compiles templates', ->
		templateHelper @