module Announcements
  class Generator < Jekyll::Generator

  	def get_annoucment_message_from_bulletin(baseurl, bulletin)
  		# <a href="bulletin/?date=6-17-2018">June 17th Bulletin</a>
  		date = Date.strptime(bulletin.basename, "%m %d %y")
  		date_month = date.strftime("%B")
  		date_day = date.day
  		day_suffix = ""

  		case date_day
  		when 1, 21
  		  day_suffix = "st"
  		when 2, 22
  		  day_suffix = "nd"
  		when 3, 23
  		  day_suffix = "rd"
  		else
  		  day_suffix = "th"
  		end

  		return {
  			'name' => "#{date_month} #{date_day}#{day_suffix}",
  			'path' => "bulletin/?date=#{date}"
  		}
  	end

    def generate(site)
      announcements = site.data["announcements"]

      #corece date into a valid date string
      announcements.each { |a|
      	a["date"] = Date.strptime(a["date"], "%m/%d/%y")
      }

      bulletins = site.static_files.select { |f| f.data["bulletin"] == true }
      bulletins = bulletins.sort_by { | bulletin | Date.strptime(bulletin.basename, "%m %d %y") }


      site.data['bulletins'] = bulletins.reverse.map { |b| get_annoucment_message_from_bulletin(site.baseurl, b) }

    end
  end
end