module.exports = (grunt) ->
	coffeeHelper = require './coffeeHelper'

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		coffeeHelper @