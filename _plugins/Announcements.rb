module Announcements
  class Generator < Jekyll::Generator
  	def get_announcement_date_from_file_modified_time(bulletin)
  		return bulletin.modified_time.strftime("%m/%d")
  	end

  	def get_newsletter_date_from_posted_time(newsletter)
  		return newsletter["posted_date"].strftime("%m/%d")
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

  	def get_annoucment_message_from_newsletter(newsletter)
  		return "<a href='newsletter/?v=" + newsletter["posted_date"].strftime("%m%d%y") + "'>" + newsletter["basename"] + " is Available!</a>"
  	end

    def generate(site)
      announcements = site.data["announcements"]
      bulletins = site.static_files.select { |f| f.data["bulletin"] == true }
      newsletter_files = site.static_files.select { |f| f.data["newsletter"] == true }

      newsletters = newsletter_files.map { |n|
      	newsletter = JSON.parse(n.to_json)
      	newsletter["posted_date"] = Date.strptime(newsletter["basename"], "%B %Y Newsletter")
      	newsletter
      }

      bulletins = bulletins.sort_by { | bulletin | Date.strptime(bulletin.basename, "%m %d %y") }
      site.data["newsletters"] = newsletters.sort_by { | newsletter | newsletter["posted_date"] }

      if(bulletins.last)
	      # Add Latest Bulletin to Announcements
	      announcements.push({
	      	"date" => get_announcement_date_from_file_modified_time(bulletins.last),
	      	"message" => get_annoucment_message_from_bulletin(bulletins.last)
	      })
	    end

      # announcements.push({
      # 	"date" => get_newsletter_date_from_posted_time(site.data["newsletters"].last),
      # 	"message" => get_annoucment_message_from_newsletter(site.data["newsletters"].last)
      # })

      #corece date into a valid date string
      announcements.each { |a|
      	a["date"] = Date.strptime(a["date"], "%m/%d")
      }


    end
  end
end