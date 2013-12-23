require
	<% _.forEach(config.requireConfig, function(value, index){ %>
	<%= index %>:<%= JSON.stringify(value) %><% }); %>
	<%= config.loads %>, (require) ->
		<%= config.req %>