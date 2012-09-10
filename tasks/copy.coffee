###global module, require###

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

	grunt.registerHelper 'hustler copy', (src, dest, config) ->
		grunt.helper 'hustler processSources'
			, src
			, dest
			, config ? {}
			, copyFile
			, copyDirectory

	grunt.registerMultiTask 'copy', 'Copies files and directories', ->
		grunt.helper 'hustler copy'
			, @file.src
			, @file.dest
			, @data