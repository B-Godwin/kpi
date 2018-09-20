require 'time'
require 'ruby-progressbar'

class Numeric
	def truncate(precision)
		self * (10*precision).floor / (10*precision)
	end

	def percent(precision)
		self.truncate(precision) * 100.0
	end
end

module Aggregators
	module Pingdom
		class Report 

			attr_reader :checks, :from, :to, :verbose, :data, :summary

			# initialise the report for a set of client ids
			# checkids is an array of pingdom check ids
			# from is the unix timestamp for the START of the aggregation period
			# to is the unix timestamp for the END of the aggregation period

			def initialize(checks, from, to, options = {}) 
				@verbose = options[:verbose] || false
				puts "Generating Pingdom uptime report for #{timestr(from)} to #{timestr(to)}" if verbose
				@checks = checks.each_with_object({}) { |e,h| h[e[:id]] = e[:name] }
				@pb = ProgressBar.create(:title => "Checks", format: "%a %P% Processed: %c from %C", :starting_at => 0, :total => @checks.length)
				# pp checks
				@from = from
				@to = to
			end

			def generate
				@data ||= checks.keys.map do |c| 
					@pb.increment
					fetch c 
				end
			end

			def fetch(i)
				res = Client.fetch_check_details id: i, tags: [:api], from: from, to: to
				aggregate(i, res)
			end

			def timestr(ts)
				Time.at(ts).strftime("%Y-%m-%d %H:%M:%S")
			end

			# process the list of check ids and aggregate the data
			def aggregate(id, details)
				values = details['summary']['days']
				times = values.map {|e| e['starttime'] }.sort
				starttime, endtime = times[0], times[times.length - 1]
				
				uptime   = values.inject(0) { |i,a| i + a['uptime'] }
				downtime = values.inject(0) { |i,a| i + a['downtime'] }
				unknown  = values.inject(0) { |i,a| i + a['unmonitored'] }

				{
					id: id, 
					name: checks[id], 
					starttime: timestr(starttime),
					endtime: timestr(endtime),
					downtime: downtime,
					uptime: uptime,
					unmonitored: unknown,
					uptime_pc: ((uptime) / (uptime + downtime + unknown).to_f).percent(6)
			    }
			end

			def summarise!

				@summary ||= 
					data.map { |e| [e[:name], e[:uptime], e[:downtime], e[:unmonitored], e[:uptime_pc]] }
						.sort{ |a,b| a[0].downcase <=> b[0].downcase }
			end

			def headers
				["API", "Uptime", "Downtime", "Unmonitored", "Uptime %"]
			end

		end
	end
end