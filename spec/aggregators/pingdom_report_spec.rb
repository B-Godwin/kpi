require 'spec_helper'

describe "Pingdom Report" do 

	let(:data) { 
		JSON.parse(File.read File.join(File.dirname(__FILE__), '..', 'fixtures', 'check-details.json'))
	}
	let(:summary) { 
		{
			starttime: "2018-09-01 00:00:00", 
			endtime: "2018-09-20 00:00:00", 
			uptime: 1692835, 
			id: 1, 
			name: "a",
			downtime: 240, 
			unmonitored: 180, 
			uptime_pc: 99.9751
		}
	}
	let(:startdate) {
		DateTime.strptime("2018-09-01", "%Y-%m-%d")
	}
	let(:enddate) {
		DateTime.strptime("2018-09-20", "%Y-%m-%d")
	}
	let(:mock_data){ 
		[{name: 'a', id: 1}, { name: 'b', id: 2}, {name: 'c', id: 3 }]
	}

	it "parses details data and aggregates it correctly" do 

		subject = Aggregators::Pingdom::Report.new(mock_data, startdate, enddate)

		res = subject.aggregate(1, data)
		expect(res).to eq(summary)
	end

	it "fetches upstream data based on the configured checks" do 
		subject = Aggregators::Pingdom::Report.new(mock_data, startdate, enddate)

		expect(subject).to receive(:fetch).exactly(3).times

		subject.generate
	end

	it "correctly calls through to the pingdom client" do 
		subject = Aggregators::Pingdom::Report.new([{'name': 'a', 'id': 1}], startdate, enddate)

		expect(subject).to receive(:fetch).with(1)

		subject.generate
	end
end