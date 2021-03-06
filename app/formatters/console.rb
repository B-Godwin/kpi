require 'tty-table'

module Formatters
	class Console

		def initialize(report)
			@data = report.summary
			@headers = report.headers
		end

		def render
			table = TTY::Table.new header: @headers, rows: @data

			table.render(:basic) #, width: 200)#, width: 140) #, resize: true)	
		end

	end
end