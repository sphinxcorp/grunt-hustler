module.exports = (grunt) ->
	crypto = require 'crypto'
	fs = require 'fs'
	path = require 'path'

	grunt.registerMultiTask 'hash', 'Renames files based on their hashed contents', ->
		@files.forEach (filePair) ->
			filePair.src.filter (filePath) ->
				unless grunt.file.exists filePath
					grunt.log.warn "Source file \" #{filePath}\" not found."

					false
				else
					true
			.map (filePath) ->
				contents = grunt.file.read filePath
				hash = crypto.createHash('sha1').update(contents).digest('hex').substr(0, 10)
				dir = path.dirname filePath
				ext = path.extname filePath
				base = path.basename filePath, ext
				newFileName = "#{base}.#{hash}#{ext}"
				newFilePath = path.join dir, newFileName

				fs.renameSync filePath, newFilePath
				grunt.verbose.ok "#{filePath} -> #{newFilePath}"