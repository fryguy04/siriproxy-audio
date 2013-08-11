require 'cora'
require 'siri_objects'
require 'pp'

# Examples: 
#   Listen to Pandora Everywhere
#   Play iTunes in Basement

class SiriProxy::Plugin::Audio < SiriProxy::Plugin
  attr_accessor :roomHash
  attr_accessor :sourceHash

  def initialize(config)
    @aRooms   	= Hash.new
    @aSources 	= Hash.new
    @aSourceApp	= Hash.new
    @aRooms   	= config["roomHash"]
    @aSources 	= config["sourceHash"]
    @aSourceApp = config["sourceApp"]
	@baseUrl	= config["baseUrl"]

  end


  listen_for /(?:Listen to|Play) (.+) (?:in|and)(?: the)? (.+)/i do |source,room|

    puts @aRooms
    puts @aSources

    source = check_hash(source.downcase, @aSources)
    room   = check_hash(room.downcase, @aRooms)

    say "Playing #{source} in the #{room}" #say something to the user!

    puts "**************************"
    cmd = "Play " + source + " in " + room
    puts cmd

    # TODO actually send message to Audio system
	
	# Launch an App if defined
	if @aSourceApp.has_key?(source)
		launch(source, @baseUrl, @aSourceApp[source])
	end

    request_completed #always complete your request! Otherwise the phone will "spin" at the user!
  end


  def check_hash(searchKey, generalHash)
	puts "In here"
	puts searchKey, generalHash

	if generalHash.has_key?(searchKey)
		return searchKey	
	else
		say "Sorry, I could not find anything named #{searchKey}."
		say "Here is the list of options."
		generalHash.each_key {|searchKey| say searchKey.capitalize}
		searchKey = ask "Which would you like to choose?"  
		check_hash(searchKey.downcase.strip, generalHash)
	end
  end


end


####
#### For auto launching an Application
class OpenLink < SiriObject
	def initialize(ref="")
		super("OpenLink", "com.apple.ace.assistant")
		self.ref = ref
	end
end

def launch(appName, baseUrl, appUrl)
 
	# Create a URL redirect file to launch App in current host's Apache dir (must be writable by siriproxy user!)
  	File.open("/var/www/" + appName + ".html", "w") do |file|
		file.puts "<html><head><title>IU Webmaster redirect</title> <META http-equiv='refresh' content='0;URL=#{appUrl}'> </head> </html>" 
	end

	fullUrl = baseUrl + appName + '.html'
	add_property_to_class(OpenLink, :ref)
	sleep (4)
	view = OpenLink.new(fullUrl.gsub("//",""))
	send_object view
end

