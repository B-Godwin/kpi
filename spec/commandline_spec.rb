require 'spec_helper'


describe Parser do 
	let(:default_st) { Date.new(Date.today.year, Date.today.month, 1) }
	let(:default_et) { Date.today }

	it "Initialises with sane defaults" do 
		opts = Parser.parse({})

		expect(opts.name).to eql("kpi")
		expect(opts.fetch_pingdom).to be_falsey
		expect(opts.fetch_jira).to be_falsey
		expect(opts.start_date).to eql(default_st)
		expect(opts.end_date).to eql(default_et)
	end

	it "Flags that it must retrieve jira tickets when the jira option is passed" do 
		opts = Parser.parse(["-j"])

		expect(opts.fetch_jira).to be_truthy
	end

	it "Flags that it must retrieve pingdom tickets when the pingdom option is passed" do 
		opts = Parser.parse(["-p"])

		expect(opts.fetch_pingdom).to be_truthy
	end

	it "Prints the help message as a default" do 

		expect(Parser).to receive(:abort)
		opts = Parser.parse(["-h"])
	end

	it "Parses a start date" do 
		opts = Parser.parse(["-s", "2018-09-03"])

		expect(opts.start_date).to eql(Date.new(2018, 9, 3))
	end

	it "Parses an end date" do 
		opts = Parser.parse(["-t" "2018-09-30"])

		expect(opts.end_date).to eql(Date.new(2018, 9, 30))
	end
end