/*global module*/

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg: '<json:package.json>',

		nodeunit: {
			tasks: ['test/**/*.js']
		},

		copy: {
			directory_to_directory: {
				src: '<%= pkg.fixtures %>directory_to_directory/',
				dest: '<%= pkg.temp %>directory_to_directory/'
			},
			array_of_directories_to_directory: {
				src: ['<%= pkg.fixtures %>array_of_directories_to_directory/a/', '<%= pkg.fixtures %>array_of_directories_to_directory/b/', '<%= pkg.fixtures %>array_of_directories_to_directory/c/'],
				dest: '<%= pkg.temp %>array_of_directories_to_directory/'
			},
			file_match_to_directory: {
				src: '<%= pkg.fixtures %>file_match_to_directory/**/*.js',
				dest: '<%= pkg.temp %>file_match_to_directory/'
			}
		},

		delete: {
			temp: {
				src: '<%= pkg.temp %>'
			}
		}
	});

	grunt.loadTasks('./tasks/');

	grunt.renameTask('test', 'nodeunit');
	grunt.registerTask('test', 'delete:temp copy nodeunit delete:temp');

	grunt.registerTask('default', 'test');
};