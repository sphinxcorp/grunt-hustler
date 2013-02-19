module.exports = (config) ->
	return if not config.data

	grunt = require 'grunt'
	fs = require 'fs'
	normalizeFilesHelper = require './normalizeFilesHelper'
	normalized = normalizeFilesHelper config
	groups = normalized.groups

	for dest, src of groups
		srcCount = src.length

		if srcCount > 1
			contents = helpers.name 'concat', src
		else
			contents = fs.readFileSync src[0]

		grunt.file.write dest, contents
		grunt.verbose.ok "#{src} -> #{dest}"