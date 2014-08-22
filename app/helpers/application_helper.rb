module ApplicationHelper
	
	# return first x chars from a given string to shorten it
	# default length is 20 chars
	def first_x_words(str, n=20, finish=' ...')
		if !str.blank?
			if str.split(' ').length > n
				return str.split(' ')[0,n].inject{|sum,word| sum + ' ' + word} + finish
			else
				return str
			end
		else
			return ""
		end
	end

	# create human readable string from seconds
	# 
	# p humanize 1234
	# #=>"20 minutes 34 seconds"
	# p humanize 12345
	# #=>"3 hours 25 minutes 45 seconds"
	# p humanize 123456
	# #=>"1 days 10 hours 17 minutes 36 seconds"
	# p humanize(Time.now - Time.local(2010,11,5))
	# #=>"4 days 18 hours 24 minutes 7 seconds"
	
	def humanize_helper(secs)
		[[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
			if secs > 0
				secs, n = secs.divmod(count)
				"#{n.to_i} #{name}"
			end
		}.compact.reverse
	end

	def humanize(secs)
		humanize_helper(secs).join(' ')
	end

	def humanize_simplify(secs)
		humanize_helper(secs)[0..1].join(' ')
	end


end
