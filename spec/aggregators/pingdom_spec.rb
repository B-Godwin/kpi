require 'rubygems'

require 'spec_helper'

describe "Pingdom Aggregator" do

	it "Correctly spans multiple tags" do 
		subject = Aggregators::Pingdom::Client

		expect(subject).to receive(:get).with({ endpoint: "https://api.pingdom.com/api/2.0/checks", params: { tags: "api,sms" }})

		res = subject.fetch_check_list(tags: [:api, :sms])

	end

	it "Fetches the list of jobs from the Pingdom api" do 
		subject = Aggregators::Pingdom::Client

		expect(subject).to receive(:get).with({ endpoint: "https://api.pingdom.com/api/2.0/checks", params: { tags: "api"}}).and_return([{job: 1}] ) 

		res = subject.fetch_check_list(tags: [:api])
		expect(res.first[:job]).to eq 1 
	end

	it "Fetches detailed stats for a check from the list of checks" do 
		subject = Aggregators::Pingdom::Client

		expect(subject).to receive(:get).with({ endpoint: "https://api.pingdom.com/api/2.1/summary.performance/1", params: { tags: "api" }})

		res = subject.fetch_check_details(id: 1, tags: [:api])
	end

end