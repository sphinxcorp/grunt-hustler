/*global module*/

module.exports = function (grunt) {
	'use strict';

	grunt.initConfig({
		pkg: '<json:package.json>',

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
		}
	});

	grunt.loadTasks('./tasks/');
	grunt.renameTask('test', 'nodeunit');
	grunt.registerTask('test', 'delete nodeunit delete');
	grunt.registerTask('default', 'test');
};