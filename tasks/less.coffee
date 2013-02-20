module.exports = (grunt) ->
	lessHelper = require './lessHelper'

	grunt.registerMultiTask 'less', 'Compile LESS to CSS', ->
		lessHelper @