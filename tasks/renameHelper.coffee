module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	fs = require 'fs'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	groups = normalized.groups

	for dest, src of groups
		src.forEach (source) ->
			fs.renameSync source, dest
			grunt.verbose.ok "#{source} -> #{dest}"