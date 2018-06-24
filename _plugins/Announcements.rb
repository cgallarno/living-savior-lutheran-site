module Announcements
  class Generator < Jekyll::Generator
  	def get_announcement_date_from_bulletin(bulletin)
  		return bulletin.modified_time.strftime("%m/%d")
  	end

  	def get_annoucment_message_from_bulletin(bulletin)
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


  		return message = "<a href=\"bulletin/?date=#{date}\">#{date_month} #{date_day}#{day_suffix} Bulletin</a>"
  	end

    def generate(site)
      announcements = site.data["announcements"]
      bulletins = site.static_files.select { |f| f.data["bulletin"] == true }

      # Add Latest Bulletin to Annoucements
      announcements.push({
      	"date" => get_announcement_date_from_bulletin(bulletins.last),
      	"message" => get_annoucment_message_from_bulletin(bulletins.last)
      })



      #corece date into a valid date string
      announcements.each { |a|
      	a["date"] = Date.strptime(a["date"], "%m/%d")
      }


    end
  end
end