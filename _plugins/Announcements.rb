module Announcements
	class Generator < Jekyll::Generator
  
	  def get_annoucment_message_from_bulletin(baseurl, bulletin)
		# Debug: Print the bulletin basename
		puts "Processing bulletin: #{bulletin.basename}"
  
		begin
		  # Extract the first 6 characters ignoring any spaces and non-numeric characters
		  date_str = bulletin.basename.gsub(/[^0-9]/, '').slice(0, 6)
		  date = Date.strptime(date_str, "%m%d%y")
		rescue => e
		  puts "Error parsing date from bulletin basename: #{bulletin.basename}"
		  puts e.message
		  raise e # Rethrow the error to stop the build process
		end
  
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
		  'path' => "/bulletin/?date=#{date}"
		}
	  end
  
	  def generate(site)
		announcements = site.data["announcements"]
  
		# Debug: Print the raw announcements data
		puts "Announcements data: #{announcements.inspect}"
  
		# Coerce date into a valid date string
		announcements.each do |a|
		  begin
			a["date"] = Date.strptime(a["date"], "%m/%d/%y")
		  rescue => e
			puts "Error parsing date from announcement: #{a.inspect}"
			puts e.message
			raise e # Rethrow the error to stop the build process
		  end
		end
  
		bulletins = site.static_files.select { |f| f.data["bulletin"] == true }
		bulletins = bulletins.sort_by do |bulletin|
		  begin
			# Extract the first 6 characters ignoring any spaces and non-numeric characters
			date_str = bulletin.basename.gsub(/[^0-9]/, '').slice(0, 6)
			Date.strptime(date_str, "%m%d%y")
		  rescue => e
			puts "Error parsing date from bulletin basename in sort: #{bulletin.basename}"
			puts e.message
			raise e # Rethrow the error to stop the build process
		  end
		end
  
		site.data['bulletins'] = bulletins.reverse.map { |b| get_annoucment_message_from_bulletin(site.baseurl, b) }
	  end
	end
  end
  