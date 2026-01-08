module Announcements
	class Generator < Jekyll::Generator
  
	  def get_annoucment_message_from_bulletin(baseurl, bulletin, site)
		# Debug: Print the bulletin basename
		puts "Processing bulletin: #{bulletin.basename}"
  
		# Extract the bulletin name without any letters
		bulletin_name = bulletin.basename.gsub(/[^0-9]/, '') + ".pdf"
  
		# Check if corresponding file exists in /inserts
		insert_file_path = File.join(site.source, "inserts", bulletin_name)
		unless File.exist?(insert_file_path)
		  puts "Warning: No corresponding insert file found for #{bulletin.basename}"
		end
  
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
  
		{
		  'name' => "#{date_month} #{date_day}#{day_suffix}",
		  'path' => "/bulletin/?date=#{date}",
		  'inserts_path' => "/inserts/#{bulletin_name}"
		}
	  end
  
	  def generate(site)
		announcements = site.collections["announcements"]&.docs || []
  
		# Coerce date into a valid date string
		announcements.each do |a|
		  next unless a.data["date"]
		  begin
			a.data["date"] = Date.parse(a.data["date"].to_s)
		  rescue => e
			puts "Error parsing date from announcement: #{a.data.inspect}"
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
  
		# Generate the data for bulletins
		site.data['bulletins'] = bulletins.reverse.map do |b|
		  bulletin_data = get_annoucment_message_from_bulletin(site.baseurl, b, site)
		  b.data.merge!(bulletin_data) # Merge the generated data into the bulletins' data
		end
	  end
	end
  end
  
