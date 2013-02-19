module.exports = (grunt) ->
	inlineTemplateHelper = require './inlineTemplateHelper'

	grunt.registerMultiTask 'inlineTemplate', 'Inlines templates', ->
		inlineTemplateHelper @