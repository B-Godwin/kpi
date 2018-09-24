require "date"
require "time"

module Aggregators
	module Jira
		class Report 

			attr_reader :issues, :from, :to, :verbose, :data, :summary

			# initialise the report for a set of incidents
			# from is the unix timestamp for the START of the aggregation period
			# to is the unix timestamp for the END of the aggregation period

			def initialize(issues, from, to, options = {}) 
				@verbose = options[:verbose] || false
				puts "Generating Jira incident query #{timestr(from)} to #{timestr(to)}" if verbose
				@issues = issues
				# pp issues
				@from = from
				@to = to
			end

			def generate
				aggregate issues
			end

			# process the list of check ids and aggregate the data
			def aggregate(issues)
				
				@totals  = { 
					"Sev1" => { count: 0, duration: 0 },
					"Sev2" => { count: 0, duration: 0 },
					"Sev3" => { count: 0, duration: 0 }
				}

				data = []

				issues.map do |i| 
					sev = i["fields"]["customfield_15605"]["value"]
					created = i["fields"]["customfield_15600"]
					finished = i["fields"]["customfield_16700"]
					postmortem = i["fields"]["customfield_16000"].gsub("https://nexmoinc.atlassian.net/wiki/spaces/IM/pages/", "/")
					key = i["key"]

					dd = datediff(created, finished)

					data << [key, sev, created, finished, dd, postmortem]
# 
					@totals[sev][:count] += 1
					@totals[sev][:duration] += dd
					# res[sev][:duratiob]÷

				end
				@data = data
				@data << [ "", "", "", "", "", ""]
				@data << [ "Totals", "count", "mean duration", "", "", "" ]
			    @totals.each_with_object(@data) do |e, v| 
			    	v << [e[0], e[1][:count], e[1][:count] > 0 ? e[1][:duration]/e[1][:count].to_f.truncate(2) : 0, "", "", ""]
			    end
				@data
			end

			def datediff(startdate, enddate) 
				(DateTime.parse(enddate).to_time.to_i - DateTime.parse(startdate).to_time.to_i)/60 # convert to minutes
			end

			def summarise!
				@summary ||= generate
			end

			def headers
				["Ticket", "Severity", "Created", "Resolved", "Duration", "Post-mortem"]
			end

		end
	end
end