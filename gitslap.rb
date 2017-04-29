#!/usr/bin/env ruby

require 'rubygems'
require 'open-uri'
require 'json'
require 'mechanize'

username = ""

@client_id = ""
@client_secret = ""

load './creds.rb'

if ! ARGV[0].nil?
	username = ARGV.join(" ")
else
	puts "Uh... You need to run it like ./gitslab username"
	exit
end

agent = Mechanize.new

def slap(username, agent)	
	
	#puts "Searching through Github API for #{username}"
	#puts "Parsing http://api.github.com/users/#{username}/events/public"

	data = agent.get("http://api.github.com/users/" + username + "/events/public?client_id=#{@client_id}&client_secret=#{@client_secret}").body()

	emails = []

	for payload in JSON.parse(data)
		if payload["payload"]["commits"]
			for commit in payload["payload"]["commits"]
				emails.push(commit["author"])
			end
		end
	end

	return emails.uniq
end

def search(query, agent)

	puts "Searching through http://api.github.com/search/users?q=#{query}"

	data = agent.get("http://api.github.com/search/users?q=#{query}").body()

	usernames = []

	for user in JSON.parse(data)["items"]
		usernames.push(user["login"])
	end

	return usernames
end
#puts slap(username, agent)
results = search(username, agent)
emails = []

puts "Found #{results.length} users..."

for user in results
	for result in slap(user, agent)
		emails.push(result)
	end
end

found = []

width = 0

for email in emails.uniq
	if email.to_s.length > width
		width = email.to_s.length
	end
	if email.to_s.downcase =~ /#{username.downcase}/
		found.push(email)
		emails.delete(email)
	end
end

top_line = ""
bottom_line = ""

for i in 0..((width - 15) / 2)
	top_line += "-"
	bottom_line += "-"
end

top_line += " High Priority "
bottom_line += "---------------"

for i in 0..((width - 15) / 2)
	top_line += "-"
	bottom_line += "-"
end

if found.length > 0
	puts top_line
	puts found
	puts bottom_line
end

puts emails
