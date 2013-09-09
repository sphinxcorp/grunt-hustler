module.exports = (grunt) ->
	path = require 'path'

	trimFileExtension = (file) ->
		ext = path.extname file
		extLength = ext.length
		fileLength = file.length

		file.substr(0, fileLength - extLength)

	trimFileExtensions = (files) ->
		files.map (file) ->
			trimFileExtension file

	getModulePaths = (modules) ->
		return [] if not modules.length > 0

		paths = modules.map (mod) ->
			for name, filePath of mod
				filePath

		paths[0]

	getSourcePaths = (cwd, src) ->
		grunt.file.expand({cwd}, src).map (filePath) ->
			filePath

	writeApp = (file, cwd, modules) ->
		mods = []

		modules.forEach (module) ->
			for name, filePath of module
				sourceFilePath = "#{cwd}#{filePath}"

				unless grunt.file.exists sourceFilePath
					grunt.log.warn "Source file \" #{sourceFilePath}\" not found."
				else
					mods.push name

		template = grunt.file.read "#{__dirname}/ngShim-templates/app.coffee"
		dest = "#{cwd}#{file}"
		compiled = grunt.template.process template, data: config: modules: JSON.stringify(mods)

		grunt.file.write dest, compiled

	writeBootstrap = (file, cwd) ->
		template = grunt.file.read "#{__dirname}/ngShim-templates/bootstrap.coffee"
		dest = "#{cwd}#{file}"
		compiled = grunt.template.process template

		grunt.file.write dest, compiled

	grunt.registerMultiTask 'ngShim', 'Creates a RequireJS main file', ->
		cwd = @data.cwd
		src = @data.src
		dest = "#{cwd}#{@data.dest}"
		angularPath = @data.angular
		angular = trimFileExtension angularPath
		modules = @data.modules
		modulePaths = getModulePaths modules
		mods = trimFileExtensions modulePaths
		appPath = 'app.coffee'
		app = trimFileExtension appPath
		bootstrapPath = 'bootstrap.coffee'
		bootstrap = trimFileExtension bootstrapPath
		sourcePaths = getSourcePaths cwd, src
		source = trimFileExtensions sourcePaths
		loads = ['require'].concat(source)

		writeApp appPath, cwd, modules
		writeBootstrap bootstrapPath, cwd

		shim = {}
		shim[angular] = deps: []

		mods.forEach (modulePath) ->
			shim[modulePath] = deps: [angular]

		shim[app] = deps: [angular].concat(mods)

		source.forEach (sourcePath) ->
			return if sourcePath is angular

			isModule = mods.indexOf(sourcePath) > -1
			ms = []

			mods.forEach (mod) ->
				return if sourcePath is mod
				return if isModule

				ms.push mod

			return if isModule
				shim[sourcePath] = deps: [angular].concat(ms)

			shim[sourcePath] = deps: [angular].concat(ms, app)

		template = grunt.file.read "#{__dirname}/ngShim-templates/main.coffee"
		compiled = grunt.template.process template, data: config: shim: JSON.stringify(shim), loads: JSON.stringify(loads)

		grunt.file.write dest, compiled