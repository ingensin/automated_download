#!/usr/bin/env ruby

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
		path = File.join(folder, @name + '.torrent')
		
		response = @http.get @link
		File.open(path, "wb") {|file| file.write(response.content)}		
		
		puts "Downloaded new torrent: " + path
	end
	
	def satisfies?(spec)
		return spec.is_match?(@name)
	end
end

class Feed
	def initialize(url)
		@url = url
	end
	
	def self.use(http)
		@@http = http
	end
	
	def load_torrents!
		response = @@http.get @url 

		xml = REXML::Document.new(response.content)
		
		@torrents = xml.elements.collect("//item") { |item| 			
			Torrent.new(
				item.elements['title'].text, 
				item.elements['link'].text, 
				@@http)
		}
	end
	
	def find_satisfying_torrents(spec)
		@torrents.find_all{|torrent| torrent.satisfies?(spec)}
	end
end

class TorrentSpec
	def initialize(spec)
		@spec = spec
	end
	
	def is_match?(torrent_name)
		torrent_name.start_with?(@spec)
	end
end

class Wish
	def initialize(spec)
		@spec = TorrentSpec.new(spec)
	end
	
	def look_in(feeds)
		feed = feeds[0] # todo: implement feed selection from wish settings
		return feed.find_satisfying_torrents(@spec)		
	end
end


http = HTTPClient.new
http.transparent_gzip_decompression = true
Feed::use(http)



feeds = [Feed.new('http://www.torrentday.com/torrents/rss?download;11;7;u=428237;tp=887f3b1d10049f24d6fddf65d2139b22')]

wishlist = ['24', 'Mountain', 'A good day to die hard']
				.map{|item| Wish.new(item)}



feeds.each {|feed| feed.load_torrents!}


for wish in wishlist
	torrents_to_consider_for_download = wish.look_in(feeds)
	torrents_to_consider_for_download.each {|torrent| torrent.download_to('c:\\temp')}
end



