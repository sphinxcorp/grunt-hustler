/*global module*/

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg: '<json:package.json>',

		test: {
			tasks: ['./test/**/*.js']
		}
	});

	grunt.loadTasks('./tasks/');

	grunt.registerTask('default', 'test');
};