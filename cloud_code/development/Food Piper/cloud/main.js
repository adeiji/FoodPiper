// Future: Given a city it will call the Factual API and get all the restaurants in that city and store them in the Parse Database
// Current: Go through all cities in the Location Table and get all the restaurants in those cities and store them in Parse

Parse.Cloud.job("getRestaurants", function (request, response) {
	var myLocation = Parse.Object.extend("Location");
	var query = new Parse.Query(myLocation);
	query.find({
		success: function (results) {
			alert("Successfully retrieved " + results.length + " cities.");		

			for (var i = 0; i < results.length; i++) {
				var location = results[i];
				alert("Location is " + location);
				var cityName = location.get("city");
				cityName = cityName.replace(" ", "%20");
				var url = 'http://api.v3.factual.com/t/restaurants-us?filters={%22locality%22:%20%22' + cityName +'%22}&include_count=true&KEY=MleIByZblcsN1V7TRLMh58AezBg5OvqT1EtZzKRM';
				getRestaurantsFromFactualAPI(url);				
			};
		},
		error: function (error) {
			alert("Error: " + error.code + " " + error.message);
		}
	});

	// Call the Factual API and get all the restaurants specified within the filters of the URL
	function getRestaurantsFromFactualAPI (url) {
		console.log("getRestaurantsFromFactualAPI() called with url: " + url);
		Parse.Cloud.httpRequest({
			url: url
		}).then(function (httpResponse) {
			// Success
			console.log(httpResponse.text);
		}, function (httpResponse) {
			// Error
			console.error("Request failed with response code " + httpResponse.status);
		});
	}

	function storeRestaurantsInParse (restaurantsJSON) {
		
	}
});
