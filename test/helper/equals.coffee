###
  Returns true if both arrays' items are the same.

  @param actual
  @param expected
  @param order (default false) if true then the order of items is required
###
equalArrayItems = (actual, expected, order = false) ->
	return false unless actual instanceof Array
	return false unless expected instanceof Array
	return false if actual.length isnt expected.length
	unless order
		# Loop 1: All values of "expected" MUST be in "actual".
		return false if (item for item in expected when actual.indexOf(item) > -1).length isnt expected.length
		# Loop 2: All values of "actual" MUST be in "expected".
		return false if (item for item in actual when expected.indexOf(item) > -1).length isnt actual.length
	else
		return false if (item for item, pos in expected when item is actual[pos]).length isnt expected.length
	true


module.exports = 

	# Returns true if both arrays' items are the same.
	equalArrayItems : equalArrayItems

	# Returns true if both objects' entries are the same (using equalArrayItems).
	equalGroups : (actual, expected, order = false) ->
		# 2 Loops: Verify that all keys of expected object are present in actual and vice versa
		for own key, expectedArray of expected
			return false unless actual[key]
		for own key, actualArray of actual
			return false unless expected[key]
		# Loop: Each key's array will be checked if they are equal.
		for own key, expectedArray of expected
			return false unless actual[key]
			return false unless equalArrayItems actual[key], expectedArray, order
		true