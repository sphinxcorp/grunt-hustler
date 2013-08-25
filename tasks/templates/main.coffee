require
	shim: <%= config.shim %>
	<%= config.loads %>, (require) ->
		angular.element(@document).ready ->
			require ['bootstrap']