module.exports = (grunt) ->
	grunt.registerMultiTask 'shimmer', 'Creates a RequireJS main file', ->
		src = @data.src

		return grunt.log.warn('src is required') if !src

		cwd = @data.cwd ? './'
		files = grunt.file.expand {cwd}, src

		return grunt.verbose.warn('No src files found') if !files.length is 0

		_ = grunt.util._
		order = @data.order ? []

		return grunt.log.warn('order must be an array') if !_.isArray(order)

		path = require 'path'

		unixifyPath = (p) ->
			regex = /\\/g
			p.replace regex, '/'

		filter = (filePath) ->
			file = path.relative cwd, filePath
			unixified = unixifyPath file
			index = files.indexOf unixified
			inSrc = index isnt -1

		expand = (glob) ->
			grunt.file.expand {cwd, filter}, glob

		groups = []

		processGroupFilePaths = (groupFilePaths) ->
			filtered = []

			groupFilePaths.forEach (groupFilePath) ->
				position = files.indexOf groupFilePath

				if position isnt -1
					filtered.push groupFilePath
					delete files[position]

			groups.push filtered

		handleArray = (group) ->
			groupFilePaths = []

			group.forEach (nestedGroup) ->
				nestedGroupFilePaths = expand nestedGroup
				groupFilePaths = groupFilePaths.concat nestedGroupFilePaths

			processGroupFilePaths groupFilePaths

		apps = {}

		handleObject = (group) ->
			for app, modules of group
				mods = []
				groupFilePaths = []

				for module, filePath of modules
					mods.push module
					groupFilePaths.push filePath

				processGroupFilePaths groupFilePaths

				# isNgApp = app.substr(0, 5) is 'NGAPP'
				# appName = if isNgApp then app.split('(')[1].split(')')[0] else app
				appName = if app is 'NGAPP' then 'app' else app

				groups.push ["#{appName}.coffee"]

				apps[app] = mods

		handleString = (group) ->
			groupFilePaths = expand group

			processGroupFilePaths groupFilePaths

		normalizeGroups = ->
			order.forEach (group) ->
				return handleString(group) if _.isString(group)
				return handleArray(group) if _.isArray(group)
				return handleObject(group) if _.isObject(group)

		normalizeGroups()

		getTemplate = (templateFileName) ->
			template = grunt.file.read "#{__dirname}/shimmer-templates/#{templateFileName}"

		createApp = (app, moduleNames) ->
			template = getTemplate 'app.coffee'

			config =
				app: app
				modules: JSON.stringify(moduleNames)

			compiled = grunt.template.process template, data: config: config
			fileName = "#{app}.coffee"
			dest = path.resolve cwd, fileName

			grunt.file.write dest, compiled

		createApps = ->
			for app, modules of apps
				appName = if app is 'NGAPP' then 'app' else app

				createApp appName, modules

		createApps apps

		req = @data.require

		createRequire = ->
			return if !req

			req = 'bootstrap.coffee' if req is 'NGBOOTSTRAP'
			template = getTemplate 'bootstrap.coffee'
			compiled = grunt.template.process template
			dest = path.resolve cwd, req

			grunt.file.write dest, compiled

		createRequire()

		loads = []

		handleRemaining = ->
			files.forEach (file) ->
				loads.push(file) if file

			groups.push loads

		handleRemaining()

		getFileNameWithoutExtension = (file) ->
			ext = path.extname file
			extLength = ext.length
			fileLength = file.length

			file.substr(0, fileLength - extLength)

		trimFiles = (preTrimmedFiles) ->
			trimmedFiles = []

			preTrimmedFiles.forEach (group) ->
				trimmedGroup = []

				group.forEach (module) ->
					trimmedModule = getFileNameWithoutExtension module

					trimmedGroup.push trimmedModule

				trimmedFiles.push trimmedGroup

			trimmedFiles

		groups = trimFiles groups

		shim = {}
		deps = []

		createShim = ->
			groups.forEach (group) ->
				group.forEach (module) ->
					shim[module] = {deps}

				deps = group

		createShim()

		loads = trimFiles([loads])[0]

		processShim = ->
			fileName = 'main.coffee'
			template = getTemplate fileName
			trimmedRequire = getFileNameWithoutExtension req

			config =
				shim: JSON.stringify(shim)
				loads: JSON.stringify(['require'].concat(loads))
				req: if req then "require ['#{trimmedRequire}']" else ''

			compiled = grunt.template.process template, data: config: config
			dest = path.resolve cwd, fileName

			grunt.file.write dest, compiled

		processShim()