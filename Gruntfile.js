module.exports = function (grunt) {
	grunt.initConfig({
		coffeeLint: {
			src: {
				src: './tasks/**/*.coffee',
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