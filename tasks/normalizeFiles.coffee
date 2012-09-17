###global module, require###

module.exports = (grunt) ->
	path = require 'path'

	grunt.registerHelper 'hustler normalizeFiles', (config) ->
		data = config.data
		dest = data.dest
		src = data.src
		files = data.files
		groups = {}

		if dest and src
			dest = path.relative './', dest
			isSrcAnArray = Array.isArray src
			src = [src] if not isSrcAnArray
			destExt = path.extname dest
			isDestADirectory = destExt.length is 0

			src.forEach (source) ->
				sourceFiles = grunt.file.expandFiles source

				sourceFiles.forEach (sourceFile) ->
					if isDestADirectory
						sourceDirectory = path.dirname source.replace '**', ''
						relative = path.relative sourceDirectory, sourceFile
						absoluteDestination = path.resolve dest, relative
						destination = path.relative './', absoluteDestination
					else
						destination = dest

					groups[destination] = [] if not groups[destination]
					groups[destination].push sourceFile

		if files
			for key, value of files
				console.log 'dest, src', key, value

		groups

	grunt.registerMultiTask 'norm', 'Normalize Files', ->
		options = grunt.helper 'hustler normalizeFiles', @

		#grunt.verbose.writeflags options, 'post options'
		console.log options

		# grunt.helper 'hustler coffee'
		# 	, @file.src
		# 	, @file.dest
		# 	, @data