require "spec_helper"

describe Aggregators::Jira::Client do
	let(:subject) { Aggregators::Jira::Client }
	let(:jql) { "project+%3D+IM+AND+createdDate+%3E%3D+2018-09-01+AND+createdDate+%3C%3D+2018-09-21+AND+Type+in+(Application,+Infrastructure)"}

	it "Generates a JQL query based on start and end date" do 
		expect(subject.jql_filter("2018-09-01", "2018-09-21")).to eql(jql)
	end
end