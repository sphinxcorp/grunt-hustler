module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	fs = require 'fs'
	rimraf = require 'rimraf'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	dirs = normalized.dirs
	groups = normalized.groups

	deleteFileObject = (command, fileObject) ->
		command fileObject
		grunt.log.ok fileObject

	deleteFile = (file) ->
		deleteFileObject fs.unlinkSync, file

	deleteDirectory = (directory) ->
		deleteFileObject rimraf.sync, directory

	for dest, src of dirs
		deleteDirectory dest

	for dest, src of groups
		src.forEach (source) ->
			exists = fs.existsSync source
			deleteFile source if exists