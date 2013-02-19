module.exports = (grunt) ->
	coffeeLintHelper = require './coffeeLintHelper'

	grunt.registerMultiTask 'coffeeLint', 'Lints CoffeeScript files', ->
		coffeeLintHelper @