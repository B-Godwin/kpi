module Aggregators
	module Jira
		class Client
			def self.endpoint
				ENV["aggregator_jira_url"]
			end

			def self.jql_filter(startdate, enddate)
				a = "project = IM AND createdDate >= #{startdate.strftime('%Y-%m-%d')} AND createdDate <= #{enddate.strftime('%Y-%m-%d')} AND Type in (Application, Infrastructure)"
			end

			# curl  --user jeremy.botha@vonage.com:UJpsXJFsvRSdGRJJZv2mB2B1
			# "https://nexmoinc.atlassian.net/rest/api/latest/search?jql=project+%3D+IM+AND+createdDate+%3E%3D
			# +startOfMonth()+AND+Type+in+(Application,+Infrastructure)&fields=customfield_15600,customfield_16700" | python -m json.tool
			def self.execute_filter startdate, enddate
				# first observed, incident resolved at, severity

				fields=%w|customfield_15600 customfield_16700 customfield_15605,summary,customfield_16000|
				jql = jql_filter(startdate, enddate)

				get endpoint: "#{endpoint}/search", params: { jql: jql, fields: fields.join(",") }
			end

			def self.get(options = {})

				res = RestClient::Request.execute method: :get,
											url: options[:endpoint],
											user: ENV["aggregator_atlassian_user"],
											password: ENV["aggregator_atlassian_apikey"],
											headers: { "Accept" => "application/json", params: options[:params] || {} }


				case res.code
					when 200
						JSON.parse(res.body)
					else
						raise "Error making JIRA api call: #{res.code}, #{res.body}"
				end
			end
		end
	end
end
