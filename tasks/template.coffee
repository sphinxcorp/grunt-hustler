module.exports = (grunt) ->
	crypto = require 'crypto'
	normalizeFilesHelper = require './normalizeFilesHelper'
	path = require 'path'

	grunt.registerMultiTask 'template', 'Compiles templates', ->
		normalized = normalizeFilesHelper @
		groups = normalized.groups
		@data.include = grunt.file.read
		data = @data

		@data.getHashedFile = (filePath, config) ->
			wildcard = '??????????'
			dir = path.dirname filePath
			ext = path.extname filePath
			base = path.basename filePath, ext
			newFileName = "#{base}.#{wildcard}#{ext}"
			newFilePath = path.join dir, newFileName
			files = grunt.file.expand newFilePath
			file = files[0]
			trim = config.trim

			if trim
				isRootRelative = trim.substr(0, 2) is './'
				trim = trim.substr(2) if isRootRelative
				trimLength = trim.length
				isMatch = file.substr(0, trimLength) is trim
				file = file.substr(trimLength) if isMatch

			file

		@data.hash = (filePath) ->
			contents = grunt.file.read filePath
			hash = crypto.createHash('sha1').update(contents).digest('hex').substr(0, 10)

		@data.uniqueVersion = ->
			uniqueVersion = Date.now()

		for dest, src of groups
			sourceContents = []

			src.forEach (source) ->
				contents = grunt.file.read source

				sourceContents.push contents

			separator = grunt.util.linefeed
			contents = sourceContents.join grunt.util.normalizelf separator
			compiled = grunt.template.process contents, data: config: data

			grunt.file.write dest, compiled
			grunt.verbose.ok "#{src} -> #{dest}"