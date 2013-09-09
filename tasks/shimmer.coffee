module.exports = (grunt) ->
	path = require 'path'

	grunt.registerMultiTask 'shimmer', 'Creates a RequireJS main file', ->
		filter = (filePath) ->
			grunt.file.exists filePath

		getFileNameWithoutExtension = (file) ->
			ext = path.extname file
			extLength = ext.length
			fileLength = file.length

			file.substr(0, fileLength - extLength)

		removeModule = (files, moduleName) ->
			files.filter (x) ->
				x isnt moduleName

		_ = grunt.util._
		src = @data.src
		req = @data.require

		return if !src
			grunt.log.warn 'src is required'

		cwd = @data.cwd ? './'

		files = grunt.file.expand({cwd, filter}, src)

		return if !files.length is 0
			grunt.verbose.warn 'No src files found'

		order = @data.order ? []

		return if !_.isArray order
			grunt.log.warn 'order must be an array'

		shim = {}
		deps = []
		moduleNames = []

		order.forEach (ord, i) ->
			return if _.isString ord
				if ord is 'NGAPP'
					shim['app'] = {deps}
					deps = ['app']
				else
					trimmed = getFileNameWithoutExtension ord
					shim[trimmed] = {deps}
					deps = [trimmed]

				files = removeModule files, ord

			return if _.isArray ord
				nextDeps = []

				ord.forEach (o) ->
					trimmed = getFileNameWithoutExtension o
					shim[trimmed] = {deps}

					nextDeps.push trimmed

					files = removeModule files, o

				deps = nextDeps

			return if _.isObject ord
				for key, value of ord
					if key is 'NGMODULES'
						nextDeps = []

						for moduleName, modulePath of value
							moduleNames.push moduleName

							trimmed = getFileNameWithoutExtension modulePath

							shim[trimmed] = {deps}

							files = removeModule files, modulePath
							nextDeps.push trimmed

						deps = nextDeps

		do ->
			fileName = 'app.coffee'
			template = grunt.file.read "#{__dirname}/shimmer-templates/#{fileName}"

			config =
				modules: JSON.stringify(moduleNames)

			compiled = grunt.template.process template, data: config: config
			dest = path.resolve cwd, fileName

			grunt.file.write dest, compiled

		do ->
			return if !req
			return if req isnt 'NGBOOTSTRAP'

			req = 'bootstrap'
			fileName = 'bootstrap.coffee'
			template = grunt.file.read "#{__dirname}/shimmer-templates/#{fileName}"

			compiled = grunt.template.process template
			dest = path.resolve cwd, fileName

			grunt.file.write dest, compiled

		do ->
			trimmedFiles = []

			files.forEach (filePath) ->
				trimmed = getFileNameWithoutExtension filePath
				trimmedFiles.push trimmed
				shim[trimmed] = {deps}

			fileName = 'main.coffee'
			template = grunt.file.read "#{__dirname}/shimmer-templates/#{fileName}"

			config =
				shim: JSON.stringify(shim)
				loads: JSON.stringify(['require'].concat(trimmedFiles))
				req: if req then "require ['#{req}']" else ''

			compiled = grunt.template.process template, data: config: config
			dest = path.resolve cwd, fileName

			grunt.file.write dest, compiled