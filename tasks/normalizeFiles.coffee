###global module, require###

module.exports = (grunt) ->
	path = require 'path'

	grunt.registerHelper 'hustler normalizeFiles', (config) ->
		data = config.data
		inDest = data.dest
		inSrc = data.src
		inFiles = data.files
		files = {}
		groups = {}

		if inFiles
			if not Array.isArray inFiles
				for inFileDest, inFileSrc of inFiles
					inFileDest = path.relative './', inFileDest
					inFileSrc = [inFileSrc] if not Array.isArray inFileSrc
					files[inFileDest] = inFileSrc

		if inDest and inSrc
			inDest = path.relative './', inDest
			inSrc = [inSrc] if not Array.isArray inSrc
			files[inDest] = inSrc

		if files
			for dest, src of files
				destExt = path.extname dest
				isDestADirectory = destExt.length is 0

				src.forEach (source) ->
					sourceExt = path.extname source
					isSourceADirectory = sourceExt.length is 0
					source = path.join source, '/**/*.*' if isSourceADirectory
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

		groups