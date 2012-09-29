###global module, require###

module.exports = (grunt) ->
	fs = require 'fs'
	rimraf = require 'rimraf'

	deleteFileObject = (command, fileObject) ->
		command fileObject
		grunt.log.ok fileObject

	deleteFile = (file) ->
		deleteFileObject fs.unlinkSync, file

	deleteDirectory = (directory) ->
		deleteFileObject rimraf.sync, directory

	grunt.registerHelper 'hustler delete', (data) ->
		normalized = grunt.helper 'hustler normalizeFiles', data
		dirs = normalized.dirs
		groups = normalized.groups

		for dest, src of dirs
			deleteDirectory dest

		for dest, src of groups
			src.forEach (source) ->
				exists = fs.existsSync source
				deleteFile source if exists

	grunt.registerMultiTask 'delete', 'Deletes files and directories', ->
		grunt.helper 'hustler delete', @