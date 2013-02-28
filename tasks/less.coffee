module.exports = (grunt) ->
	fs = require 'fs'
	less = require 'less'
	path = require 'path'
	normalizeFilesHelper = require './normalizeFilesHelper'

	grunt.registerMultiTask 'less', 'Compile LESS to CSS', ->
		done = @async()
		normalized = normalizeFilesHelper @
		groups = normalized.groups

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
			grunt.util.async.map srcFiles, compileLessFile, (err, results) ->
				return callback err if err

				callback null, results.join grunt.util.linefeed

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