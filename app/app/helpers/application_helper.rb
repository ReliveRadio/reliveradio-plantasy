module ApplicationHelper
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
end
