module.exports = (grunt) ->
	grunt.registerMultiTask 'shimmer', 'Creates a RequireJS main file', ->
		src = @data.src
		requireConfig = @data.requireConfig ? {}

		return grunt.log.warn('src is required') if !src

		cwd = @data.cwd ? './'
		destPath = @data.dest ? "./"
		files = grunt.file.expand {cwd}, src
		path = require 'path'

		deDupe = ->
			previousFile = null

			files.forEach (file, index) ->
				dirname = path.dirname file
				ext = path.extname file
				basename = path.basename file, ext

				if previousFile and previousFile.dirname is dirname and previousFile.basename is basename and previousFile.ext is '.coffee' and ext is '.js'
					delete files[index]

				previousFile = {
					dirname
					ext
					basename
				}

		deDupe()

		return grunt.verbose.warn('No src files found') if !files.length is 0

		_ = grunt.util._
		order = @data.order ? []

		return grunt.log.warn('order must be an array') if !_.isArray(order)

		removeFromFiles = (filePath) ->
			position = files.indexOf filePath

			if position isnt -1
				delete files[position]

		mainFileName = 'main.coffee'

		removeFromFiles mainFileName

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
				appFile = "#{appName}.coffee"

				removeFromFiles appFile
				groups.push [appFile]

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
			dest = path.resolve cwd, destPath + fileName

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
			dest = path.resolve cwd, destPath + req

			removeFromFiles req
			grunt.file.write dest, compiled

		createRequire()

		loads = []

		handleRemaining = ->
			files.forEach (file) ->
				console.log 'remaining', file
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

		requireConfig.shim = {}
		deps = []

		createShim = ->
			groups.forEach (group) ->
				group.forEach (module) ->
					requireConfig.shim[module] = {deps}

				deps = group

		createShim()

		loads = trimFiles([loads])[0]

		processShim = ->
			template = getTemplate mainFileName
			trimmedRequire = getFileNameWithoutExtension req

			config =
				requireConfig: requireConfig
				loads: JSON.stringify(['require'].concat(loads))
				req: if req then "require ['#{trimmedRequire}']" else ''

			compiled = grunt.template.process template, data: config: config
			dest = path.resolve cwd, destPath + mainFileName

			grunt.file.write dest, compiled

			console.log "written main file to #{dest}"

		processShim()