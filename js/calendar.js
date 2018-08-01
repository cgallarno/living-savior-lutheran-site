// A Category contains an array of recurring event Id's that fall into that category.
var calendarRepo = {
	categories: {
		chior: [
			"8giptdo9cttq8dh9it4oqg8g0g" //Chior
		],
		church: [
			"dt1i5vc6v499k9v5gl8qrl98gs",
			"fhjnjlpr4qgprji1c011133h54", //Worship Service
			"45dnqjq1k71f5kr8v7m905gvis" // Worship Service
		],
		mensFellowship: [
			"e9rn5vk0fnlfe0hqr7olk93vas", //Men's Christian Fellowship Dinner
			"3aj3dpsvjlqiju3suv7ngdm3cc" //Men's Christian Fellowship Breakfast
		],
		youth: [],
		womensFellowship: [
			"7d15fepi6naqjjnsh8qcmaq8ek" // Women in Prayer
		],
		socialMinistry: [],
		preschool: [],
		bibleStudies: [
			"e5iprv983s4d0mg7knobivhn3g" // Lifelight
		]
	},
	parseEventProperties: function (event) {
		// Get Title, Location, Category, Display Month, date, and time
		var props = {};

		var category = _.findKey(calendarRepo.categories, function(c){
			return _.indexOf(c, event.recurringEventId) > -1;
		});

		var dateToUse = event.start.dateTime || event.start.date;
		var date = moment();

		props.category = category ? _.words(category).join(' ') : '';
		props.date = {
			month:  date.format('MMM'),
			day: date.date(),
			time: date.format('h:mm a')
		};
		props._date = date;
		props.title = event.summary;

		return props;
	},
	get: function (count, callback) {
		$.ajax({
			url: 'https://www.googleapis.com/calendar/v3/calendars/secretary@livingsaviorlutheran.org/events',
			data: {
				'key': 'AIzaSyBTF2W7V-YyjES-ABM45yA1twkJsmFBQ5A',
				'timeMin': moment().format("YYYY-MM-DDTHH:mm:ssZ"),
				'singleEvents': true,
				'orderBy': 'startTime',
				'maxResults': count
			},
			dataType: 'json',
			success: function (response) {
				var events = [];
				$.each(response.items, function (i, event) {
					events.push(_.merge({}, event, calendarRepo.parseEventProperties(event)));
				});

				console.log("The Events", events);

				if(callback){
					callback(events);
				}
			},
			error: function (res) {

			}
		});
	}
};