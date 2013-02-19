module.exports = (grunt) ->
	fs = require 'fs'
	less = require 'less'
	path = require 'path'
	helpers = require('grunt-lib-legacyhelpers').init(grunt)

	compileLessFile = (source, callback) ->
		dir = path.dirname source

		parser = new less.Parser
			paths: [dir]
			filename: source

		fs.readFile source, 'utf8', (err, data) ->
			callback err if err

			parser.parse data, (err, tree) ->
				callback err if err

				css = null

				try
					css = tree.toCSS()
				catch e
					return callback e

				callback null, css

	processLessFiles = (srcFiles, callback) ->
		grunt.utils.async.map srcFiles, compileLessFile, (err, results) ->
			return callback err if err

			callback null, results.join grunt.utils.linefeed

	helpers['hustler less'] = (config) ->
		done = config.async()
		normalized = helpers['hustler normalizeFiles'] config
		groups = normalized.groups

		for dest, src of groups
			sourceContents = []

			processLessFiles src, (err, css) ->
				return if err
					grunt.log.error err
					done false

				destination = dest.replace '.less', '.css'

				grunt.file.write destination, css
				grunt.verbose.ok "#{src} -> #{destination}"
				done()

	grunt.registerMultiTask 'less', 'Compile LESS to CSS', ->
		helpers['hustler less'] @