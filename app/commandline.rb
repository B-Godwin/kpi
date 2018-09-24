require 'optparse'
require 'optparse/date'

Options = Struct.new(:name, :fetch_pingdom, :fetch_jira, :start_date, :end_date, :set)

class Parser
  def self.parse_commandline
  	parse(arguments)
  end

  def self.parse(options)
    args = Options.new("kpi", false, false, Date.new(Date.today.year, Date.today.month, 1), Date.today, false)

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: ./kpi.sh [options]"

      opts.on("-p",  "Aggregate pingdom uptime stats for api filtered checks") do 
        args.fetch_pingdom = true
        args.set = true
      end

      opts.on("-j", "Aggregate jira issue tickets for sv1 - sv3 issues") do 
      	args.fetch_jira = true
      	args.set = true
      end

      opts.on("-sDATE", Date, "Start date for the reporting range [default first of the month]") do |d|
      	args.start_date = d
      	args.set = true
      end

      opts.on("-tDATE", Date, "End date for the reporting range [default todays date]") do |d| 
      	args.end_date = d 
      	args.set = true
      end

      opts.on_tail("-h", "Prints these usage instructions") do
        args.set = false
      end
    end

    opt_parser.parse!(options)
    abort(opt_parser) unless args.set
    return args
  end

  def self.abort(opt_parser)
  	puts opt_parser
  end

  def self.arguments
  	ARGV
  end
end


