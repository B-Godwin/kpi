require "spec_helper"

describe Aggregators::Jira::Client do
	let(:subject) { Aggregators::Jira::Client }
	let(:jql) { "project = IM AND createdDate >= 2018-09-01 AND createdDate <= 2018-09-21 AND Type in (Application, Infrastructure)"}

	it "Generates a JQL query based on start and end date" do 
		expect(subject.jql_filter(Date.strptime("2018-09-01"), Date.strptime("2018-09-21"))).to eql(jql)
	end
end