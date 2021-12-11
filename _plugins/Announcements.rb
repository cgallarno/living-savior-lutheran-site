module Announcements
  class Generator < Jekyll::Generator

    def generate(site)
      announcements = site.data["announcements"]

      #corece date into a valid date string
      announcements.each { |a|
      	a["date"] = Date.strptime(a["date"], "%m/%d/%y")
      }

    end
  end
end