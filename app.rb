require 'rubygems'
require 'optparse'

require 'bundler/setup'
require 'rest-client'
require 'dotenv/load'
require 'json'

Dir[File.expand_path "app/**/*.rb"].each{|f| require_relative(f)}


# aggregate pingdom stats

res = Aggregators::Pingdom::Client.fetch_check_list tags: [:api]

checks = res['checks'].map {|c| { name: c['name'], id: c['id'] }}

rep = Aggregators::Pingdom::Report.new(checks,  1535756400, 1537398000, verbose: true)

rep.generate
rep.summarise!

# pp rep.data

puts Formatters::Console.new(rep).render


