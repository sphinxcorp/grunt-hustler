grunt = require 'grunt'
fs = require 'fs'
directoryToDirectory = './temp/directory_to_directory/'
arrayOfDirectoriesToDirectory = './temp/array_of_directories_to_directory/'
fileMatchToDirectory = './temp/file_match_to_directory/'

exports['copy'] = {
	setUp: (done) ->
		done()
	'directory to directory': (test) ->
		test.expect 2

		test.equal true, fs.existsSync "#{directoryToDirectory}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{directoryToDirectory}b.js", 'should find b.js'

		test.done()
	'array of directories to directory': (test) ->
		test.expect 3

		test.equal true, fs.existsSync "#{arrayOfDirectoriesToDirectory}a.js", 'should find a.js'
		test.equal true, fs.existsSync "#{arrayOfDirectoriesToDirectory}b.js", 'should find b.js'
		test.equal true, fs.existsSync "#{arrayOfDirectoriesToDirectory}d/d.js", 'should find d.js inside d directory'

		test.done()
	# 'file match to directory': (test) ->
	# 	test.expect 2

	# 	test.equal true, fs.existsSync "#{fileMatchToDirectory}a.js", 'should find a.js'
	# 	test.equal true, fs.existsSync "#{fileMatchToDirectory}b.js", 'should find b.js'
	# 	test.equal false, fs.existsSync "#{fileMatchToDirectory}c.html", 'should not find c.html'

	# 	test.done()
}