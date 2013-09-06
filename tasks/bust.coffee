module.exports = (grunt) ->
	crypto = require 'crypto'
	fs = require 'fs'
	path = require 'path'

	grunt.registerMultiTask 'bust', 'Renames files based on their hashed contents. Replaces their references.', ->
		@files.forEach (f) ->
			f.src.filter (filePath) ->
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
				f.replaceIn.files.forEach (file) ->
					replaceFiles = grunt.file.expand file
					if replaceFiles.length > 0
						contents = grunt.file.read replaceFiles[0]
						exp = new RegExp "#{base}#{ext}", "g"
						contents = contents.replace exp, newFileName
						grunt.file.write replaceFiles[0], contents

				fs.renameSync filePath, newFilePath
				grunt.verbose.ok "#{filePath} -> #{newFilePath}"