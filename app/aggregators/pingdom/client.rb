module Aggregators
	module Pingdom
		class Client

			def self.endpoint
				ENV['aggregator.pingdom.url']
			end

			def self.tagstring(taglist)
				taglist && !taglist.empty? ? { tags: taglist.join(",") } : {}
			end

			# fetch the list of checks bound to the pingdom account, filtered by optional tag
			def self.fetch_check_list(options = {})
				get endpoint: "#{endpoint}/2.0/checks", 
					params: tagstring(options[:tags])
			end


			# fetch the remote details of a particular check
			def self.fetch_check_details(options = {})
				get endpoint: "#{endpoint}/2.1/summary.performance/#{options[:id]}", 
					params: tagstring(options[:tags]).merge({
						resolution: :day,
						from: options[:from],
						to: options[:to],
						includeuptime: true
					})
			end


			def self.get(options = {})
				res = RestClient::Request.execute method: :get, 
											url: options[:endpoint],
											user: ENV['aggregator.pingdom.user'], 
											password: ENV['aggregator.pingdom.passwd'],
											headers: { "app-key" => ENV["aggregator.pingdom.appkey"], "Accept" => "application/json", params: options[:params] }

				case res.code
					when 200
						JSON.parse(res.body)
					else
						raise "Error making pingdom api call: #{res.code}, #{res.body}"
				end
			end
		end
	end
end