require 'cora'
require 'siri_objects'
require 'pp'

#######
######

class SiriProxy::Plugin::Audio < SiriProxy::Plugin
  attr_accessor :roomHash
  attr_accessor :sourceHash

  def initialize(config)
    @aRooms   = Hash.new
    @aSources = Hash.new
    @aRooms   = config["roomHash"]
    @aSources = config["sourceHash"]

  end


  # Play pandora in the kitchen
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
