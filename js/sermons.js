var booksOfTheBible = ["Genesis", "Exodus", "Leviticus", "Numbers", "Deuteronomy", "Joshua", "Judges", "Ruth", "1 Samuel", "2 Samuel", "1 Kings", "2 Kings", "1 Chronicles", "2 Chronicles", "Ezra", "Nehemiah", "Esther", "Job", "Psalms", "Proverbs", "Ecclesiastes", "Song of Solomon", "Isaiah", "Jeremiah", "Lamentations", "Ezekiel", "Daniel", "Hosea", "Joel", "Amos", "Obadiah", "Jonah", "Micah", "Nahum", "Habakkuk", "Zephaniah", "Haggai", "Zechariah", "Malachi", "Matthew", "Mark", "Luke", "John", "Acts", "Romans", "1 Corinthians", "2 Corinthians", "Galatians", "Ephesians", "Philippians", "Colossians", "1 Thessalonians", "2 Thessalonians", "1 Timothy", "2 Timothy", "Titus", "Philemon", "Hebrews", "James", "1 Peter", "2 Peter", "1 John", "2 John", "3 John", "Jude", "Revelation"];
var sermonsRepo = {
	corrections: {
		'/videos/197813692' : '"How\'s Your Memory" By Rev. Andrew C. Lissy Paslm 25:6-7 01_01_2017',
		'/videos/149568851' : '"He is Peace" By Vicar Aaron Bird Micah 5:2-5 12_20_2015',
		'/videos/149996913' : '"A Mixed Up Day" By Rev. Andrew C. Lissy Luke 1:37-54 12_24_2015',
		'/videos/183206935' : '"How Do We Measure Love" By Rev. Andrew C. Lissy Amos 8:4-7 09_18_2016',
		'/videos/196183699' : '"It seemed like a good idea at the time" By Vicar Kevin Barron Matthew 1:18-25 12_18_2016',
		'/videos/164014105' : '"Rev. Lannon Martin of Concordia Seminary, Ft. Wayne, IN" Rev. Lannon Martin',
		'/videos/421799804' : 'Ascension Sunday 05_24_2020',
		'/videos/416586892' : 'Fifth Sunday of Easter 05_10_2020',
		'/videos/411667452' : 'Third Sunday of Easter 26 April 2020'.
		'/videos/426462427' : 'Trinity Sunday 06_07_2020'
	},
	previewOffsets : {
		'/videos/203747965' : -45,
		'/videos/193259374' : -90,
		'/videos/196183699' : -90,
		'/videos/198606175'	: -90,
		'/videos/202657419' : -90,
		'/videos/208022646' : -90,
		'/videos/235241861' : -90,
		'/videos/271007808' : -90,
		'/videos/335723965' : -90
	},
	parseVideoProperties: function(video) {
		var props = {}; // title, date, passageString, speaker
		var sourceTitle = video.name;

		if(sermonsRepo.corrections[video.uri]){
			sourceTitle = sermonsRepo.corrections[video.uri];
		}

		var dateMatch = sourceTitle.match(/(\d{1,2}_\d{1,2}_\d{4})/);
		if(dateMatch && dateMatch.length > 0){
			sourceTitle = sourceTitle.slice(0, dateMatch.index).trim();
			props.date = moment(dateMatch[0], 'MM_DD_YYYY');
		}else{
			props.date = moment(video.created_time);
		}

		sourceTitle = sourceTitle.replace(/[\u201C\u201D]/g, '"');
		var titleMatch = sourceTitle.match(/"(.*?[^\\])"/);
		if(titleMatch && titleMatch.length){
			if(titleMatch[1]){
				props.title = titleMatch[1];
			}else{
				props.title = titleMatch[0];
			}
			sourceTitle = sourceTitle.slice(titleMatch.index + titleMatch[0].length, sourceTitle.length);
		}else{

		}

		props.passageString = '';
		_.each(booksOfTheBible, function(book){
			var index = sourceTitle.lastIndexOf(book);

			if(index > -1){
				props.passageString = ' / ' + sourceTitle.slice(index, sourceTitle.length);
				sourceTitle = sourceTitle.slice(0, index);
				return false; // Exit foreach
			}
		});


		props.speaker = '';
		if(!props.title){
			// If no title was found, assing it what remains fo the original title minus the other details
			props.title = sourceTitle;
		}else{
			// we can safely assume the rest is the speaker
			props.speaker = _.trimStart(sourceTitle, ' By');
		}

		console.log("'" + video.uri + "'" + " : " + "'" + video.name + "'");

		return props;
	},
	get: function(count, callback){
		$.ajax({
			url: 'https://api.vimeo.com/users/13168873/videos',
			data: {
				'filter_embeddable': true,
				'filter_playable': true,
				'per_page': count
			},
			dataType: 'json',
			headers: {
				'Authorization': 'Bearer 97a2f8f48205387b6f30b5ca412b80c5'
			},
			success: function (response) {
				$("#sermons-total").text(" " + response.total + " ");

				var sermons = [];
				$.each(response.data, function (key, video) {
					sermons.push(_.merge({}, video, sermonsRepo.parseVideoProperties(video)));
				});
				callback(sermons);
			}
		});
	}
};