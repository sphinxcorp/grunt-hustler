/*global module*/

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg: '<json:package.json>',

		test: {
			tasks: ['./test/**/*.js']
		},

		delete: {
			dist: {
				src: '<%= pkg.dist %>'
			}
		},

		coffee: {
			dist: {
				src: '<%= pkg.src %>',
				dest: '<%= pkg.dist %>',
				bare: true
			}
		},

		watch: {
			coffee: {
				files: '<%= pkg.src %>**/*.coffee',
				tasks: 'coffee test'
			}
		}
	});

	grunt.loadTasks('./src/');

	grunt.registerTask('core', 'delete coffee test');
	grunt.registerTask('default', 'core');
	grunt.registerTask('dev', 'core watch');
	grunt.registerTask('prod', 'core');
};