module.exports = (grunt) ->
	path = require 'path'

	grunt.registerMultiTask 'ngShim', 'Renames files based on their hashed contents', ->
		trim = @data.options.trim

		trimPath = (filePath) ->
			file = filePath

			if trim
				trimLength = trim.length
				isMatch = filePath.substr(0, trimLength) is trim
				file = filePath.substr(trimLength) if isMatch

			ext = path.extname file
			extLength = ext.length
			fileLength = file.length
			file = file.substr(0, fileLength - extLength)

		angular = trimPath @data.angular
		modules = []
		app = trimPath @data.app
		bootstrap = trimPath @data.bootstrap
		appDependencies = [angular]
		moduleDependencies = [angular, app]
		loads = ['require']

		main = {
			shim: {}
		}

		@data.modules.forEach (module) ->
			mod = trimPath module
			main.shim[mod] = deps: [angular]

			modules.push mod
			appDependencies.push mod
			moduleDependencies.push mod

		main.shim[app] = {deps: appDependencies}

		@files.forEach (f) ->
			f.src.filter (filePath) ->
				unless grunt.file.exists filePath
					grunt.log.warn "Source file \" #{filePath}\" not found."

					false
				else
					true
			.map (filePath) ->
				file = trimPath filePath

				return if file is angular
				return if modules.indexOf(file) isnt -1
				return if file is app
				return if file is bootstrap

				main.shim[file] = {deps: moduleDependencies}

				loads.push file

		template = grunt.file.read '/templates/main.coffee'
		compiled = grunt.template.process template, data: config: shim: JSON.stringify(main.shim), loads: JSON.stringify(loads)

		grunt.file.write @data.dest, compiled