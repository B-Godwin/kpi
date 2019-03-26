require 'rubygems'

require 'bundler/setup'
require 'rest-client'
require 'dotenv/load'
require 'json'
require 'bitly'

Bitly.use_api_version_3
$bitly = Bitly.new(ENV["bitly_username"], ENV["bitly_apikey"])

Dir[File.expand_path "app/**/*.rb"].each{|f| require_relative(f)}

options = Parser.parse_commandline
# aggregate pingdom stats

if options.fetch_pingdom
	puts "Retrieving pingdom stats for #{options.start_date} to #{options.end_date}"
	res = Aggregators::Pingdom::Client.fetch_check_list tags: [:api]

	checks = res['checks'].map {|c| { name: c['name'], id: c['id'] }}

	rep = Aggregators::Pingdom::Report.new(checks,  options.start_date, options.end_date, verbose: true)

	rep.generate
	rep.summarise!

# pp rep.data

	puts Formatters::Console.new(rep).render
end

if options.fetch_jira
	puts "Retrieving jira stats for #{options.start_date} to #{options.end_date}"

	res = Aggregators::Jira::Client.execute_filter(options.start_date, options.end_date)

	# pp res

	rep = Aggregators::Jira::Report.new(res["issues"], options.start_date, options.end_date)

	rep.summarise!

	puts "Post mortem url: https://nexmoinc.atlassian.net/wiki/spaces/IM/pages/\n\n"
	puts Formatters::Console.new(rep).render
end
