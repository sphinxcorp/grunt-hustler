###global module, require###

module.exports = (grunt) ->
	coffee = require 'coffee-script'
	path = require 'path'

	grunt.registerHelper 'hustler coffee', (src, dest, config) ->
		grunt.helper 'hustler processSources'
			, src
			, dest
			, config ? {}
			, coffeeFile
			, coffeeDirectory

	notify = (from, to) ->
		grunt.log.ok "#{from} -> #{to}"

	coffeeFile = (file, source, config, dest) ->
		bare = config.bare ? false
		contents = grunt.file.read file
		compiled = coffee.compile contents, {bare}
		destExt = path.extname dest
		isDestAFile = destExt.length > 0

		return if isDestAFile
			grunt.file.write dest, contents
			notify file, dest

		sourceDirectory = path.dirname source.replace '**', ''
		relative = path.relative sourceDirectory, file
		destination = (path.resolve dest, relative).replace('.coffee', '.js')

		grunt.file.write destination, compiled

		relativeDestination = path.relative './', destination

		notify file, relativeDestination

	coffeeDirectory = (directory, source, config, dest) ->
		src = "#{directory}**/*.coffee"

		grunt.helper 'hustler coffee'
			, src
			, dest
			, config

	grunt.registerMultiTask 'coffee', 'Compile CoffeeScript to JavaScript', ->
		grunt.helper 'hustler coffee'
			, @file.src
			, @file.dest
			, @data