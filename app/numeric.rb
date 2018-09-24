
class Numeric
	def truncate(precision)
		self * (10*precision).floor / (10*precision)
	end

	def percent(precision)
		self.truncate(precision) * 100.0
	end
end