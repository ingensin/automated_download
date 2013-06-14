require 'httpclient'
require 'rexml/document'



class Torrent
	def initialize(name, link, http)
		@name = name
		@link = link
		@http = http
	end
	
	def to_s
		@name + " " + @link
	end
	
	def download_to(folder)
		p URI.parse(@link).component
		
		response = @http.get @link
		#File.open(folder + "test.torrent", "wb") {|file| file.write(response.content)}		
	end
end

class Feed
	def initialize(url)
		@url = url
	end
	
	def self.use(http)
		@@http = http
	end
	
	def load_torrents
		response = @@http.get @url 

		xml = REXML::Document.new(response.content)
		
		xml.elements.collect("//item") { |item| 			
			Torrent.new(item.elements['title'].text, item.elements['link'].text, @@http)
		}
	end
end


http = HTTPClient.new
http.transparent_gzip_decompression = true

Feed::use(http);



feeds = [Feed.new('http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22')]



for feed in feeds
	
	torrents = feed.load_torrents
	for torrent in torrents
		torrent.download_to('c:\\temp\\')
		break
	end
end



