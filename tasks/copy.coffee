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
# 		src: './src/**/*.ext',
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

	copyFile = (file, source, config, dest) ->
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

	copyDirectory = (directory, source, config, dest) ->
		merge = config.merge ? true
		destDirectory = path.dirname dest

		wrench.mkdirSyncRecursive destDirectory, 0o0777
		wrench.copyDirSyncRecursive directory, dest, preserve: merge

		relativeDestination = path.relative './', dest

		notify directory, relativeDestination

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		grunt.helper 'processSources'
			, @file.src
			, @file.dest
			, @data
			, copyFile
			, copyDirectory