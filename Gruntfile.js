module.exports = function (grunt) {
	grunt.initConfig({
		nodeunit: {
			tasks: [
				'./test/**/!(deleteSpec.js)*.js',
				'./test/**/deleteSpec.js'
			]
		},

		coffee: {
			src: {
				src: './tasks/*.coffee',
				dest: './temp/tasks/',
				bare: true
			},
			test: {
				src: './test/*.coffee',
				dest: './temp/test/',
				bare: true
			}
		},

		coffeeLint: {
			src: {
				src: './tasks/*.coffee',
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
				src: './test/*.coffee',
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

		copy: {
			src: {
				src: './tasks/*.coffee',
				dest: './temp/tasks/'
			},
			test: {
				src: './test/*.coffee',
				dest: './temp/test/'
			}
		},

		delete: {
			temp: {
				src: './temp/'
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
		},

		template: {
			test: {
				src: './tasks/zebra.template',
				dest: './temp/zebra.html'
			}
		}
	});

	grunt.loadTasks('./tasks/');
	// grunt.renameTask('test', 'nodeunit');
	// grunt.registerTask('test', 'delete nodeunit delete');
	// grunt.registerTask('default', 'test');
};