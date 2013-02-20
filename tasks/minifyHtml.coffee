module.exports = (grunt) ->
	minifyHtmlHelper = require './minifyHtmlHelper'

	grunt.registerMultiTask 'minifyHtml', 'Minifies Html', ->
		minifyHtmlHelper @