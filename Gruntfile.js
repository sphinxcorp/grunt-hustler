module.exports = function (grunt) {
	grunt.initConfig({
		nodeunit: {
			tasks: [
				'./test/**/!(deleteSpec.js)*.js',
				'./test/**/deleteSpec.js'
			]
		},

		delete: {
			temp: {
				src: './temp/'
			}
		},

		coffee: {
			src: {
				src: './tasks/coffee.coffee',
				dest: './tasks/',
				bare: true
			},
			test: {
				src: './test/coffeeSpec.coffee',
				dest: './test/',
				bare: true
			}
		},

		coffeeLint: {
			src: {
				src: './tasks/coffee.coffee',
				// Use one tab for indentation.
				indentation: {
					value: 1,
					level: 'error'
				},
				// No maximum line length.
				max_line_length: {
					level: 'ignore'
				},
				// Using tabs should not result in an error.
				no_tabs: {
					level: 'ignore'
				}
			},
			test: {
				src: './test/coffeeSpec.coffee',
				// Use one tab for indentation.
				indentation: {
					value: 1,
					level: 'error'
				},
				// No maximum line length.
				max_line_length: {
					level: 'ignore'
				},
				// Using tabs should not result in an error.
				no_tabs: {
					level: 'ignore'
				}
			}
		},

		watch: {
			src: {
				files: './tasks/**/*.coffee',
				tasks: 'coffee test'
			},
			test: {
				files: './test/**/*.coffee',
				tasks: 'coffee test'
			}
		}
	});

	grunt.loadTasks('./tasks/');
	// grunt.renameTask('test', 'nodeunit');
	// grunt.registerTask('test', 'delete nodeunit delete');
	// grunt.registerTask('default', 'test');
};