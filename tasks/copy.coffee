###global module, require###

# copy: {
# 	directory_to_directory: {
# 		src: './src/',
# 		dest: './dest/'
# 	},
# 	array_of_directories_to_directory: {
# 		src: ['./src/scripts/', './src/styles/'],
# 		dest: './dest/'
# 	},
# 	array_of_directories_and_files_to_directory: {
# 		src: ['./src/scripts/', './src/styles/', './src/img/**/*.png'],
# 		dest: './dest/'
# 	},
# 	file_match_to_directory: {
# 		src: './src/*.ext',
# 		dest: './dest/'
# 	},
# 	file_to_directory: {
# 		src: './src/file.ext',
# 		dest: './dest/'
# 	},
# 	file_to_file: {
# 		src: './src/file.ext',
# 		dest: './dest/file.ext'
# 	}
# }
module.exports = (grunt) ->
	fs = require 'fs'
	path = require 'path'
	wrench = require 'wrench'
	_ = grunt.utils._

	notify = (from, to) ->
		grunt.log.ok "#{from} -> #{to}"

	copyDirectories = (directories, dest, merge) ->
		directories.forEach (directory) ->
			destDirectory = path.dirname dest

			wrench.mkdirSyncRecursive destDirectory, 0o0777
			wrench.copyDirSyncRecursive directory, dest, preserve: merge

			relativeDestination = path.relative './', dest

			notify directory, relativeDestination

	copyFiles = (files, dest, source) ->
		files.forEach (file) ->
			contents = grunt.file.read file
			destExt = path.extname dest
			isDestAFile = destExt.length > 0

			return if isDestAFile
				grunt.file.write dest, contents
				notify file, dest

			sourceDirectory = path.dirname source.replace '**', ''
			relative = path.relative sourceDirectory, file
			destination = path.resolve dest, relative

			grunt.file.write destination, contents

			relativeDestination = path.relative './', destination

			notify file, relativeDestination

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		src = @file.src
		dest = @file.dest
		config = @data
		merge = config.merge ? true
		sources = src
		isArray = _.isArray src

		if not isArray
			sources = []
			sources.push src

		sources.forEach (source) ->
			sourceExists = fs.existsSync source

			return if not sourceExists

			directories = grunt.file.expandDirs source
			files = grunt.file.expandFiles source

			copyDirectories directories, dest, merge
			copyFiles files, dest, source