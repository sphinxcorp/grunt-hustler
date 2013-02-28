module.exports = function (grunt) {
	grunt.initConfig({
		coffee: {
			scripts: {
				files: {
					'./temp/scripts/': './tasks/**/*.coffee'
				},
				bare: true
			}
		},

		coffeeLint: {
			scripts: {
				files: './tasks/**/*.coffee',
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
			scripts: {
				files: {
					'./temp/dest/': './tasks/'
				}
			}
		},

		delete: {
			scripts: {
				files: './temp/'
			}
		},

		inlineTemplate: {
			views: {
				files: {
					'./temp/views/views.html': './views/**/*.html'
				},
				type: 'text/ng-template'
			}
		},

		less: {
			styles: {
				files: {
					'./temp/styles/': './styles/**/*.less'
				}
			}
		},

		minifyHtml: {
			views: {
				files: {
					'./temp/views/': './views/**/*.html',
					'./temp/views/view.min.html': './views/**/*.html'
				}
			}
		},

		rename: {
			views: {
				files: {
					'./temp/views/people.new.html': './temp/views/people.html'
				}
			}
		},

		template: {
			views: {
				files: {
					'./temp/templateViews': './views/**/*.template'
				},
				environment: 'prod'
			}
		},

		watch: {
			src: {
				files: './tasks/**/*.coffee',
				tasks: 'coffeeLint'
			}
		}
	});

	grunt.loadTasks('./tasks/');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask('default', [
		'coffeeLint',
		'watch'
	]);
};