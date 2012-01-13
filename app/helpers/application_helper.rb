module ApplicationHelper
  # Dirk Roorda's word counting code (originally in Perl)
  def find_charpos_by_word_number(text, word_number)
	elementstack = Array.new
	wordpos = 0;
	charpos = 0;
	rest = text
	while wordpos < word_number and rest != "" 
		if rest =~ /<[^>]+>/ then
			pre = $`;
			tag = $&;
			rest = $';
		else
			pre = rest
			tag = ""
			rest = ""
		end
		if not elementstack.empty? then
			charpos += pre.length
		else 
			prerep = pre;
			prerep.sub(/^\s+/,'')
			prerep.sub(/\s+$/,'')
			prewords = prerep.split(/\s+/)
			if prewords.length < word_number - wordpos then
				charpos += pre.length;
				wordpos += prewords.length;
			else
				rest = pre;
				while wordpos < word_number and rest != ""
					if rest =~ /^\S+|\s+/
						item = $&
						rest = $'
					else
						item = rest
						rest = ''
					end
					isblank = item =~ /\s/
					if not isblank then
						wordpos += 1
						if wordpos < word_number then
							charpos += item.length
						end
					else
						charpos += item.length
					end
				end
			end
		end
		if wordpos < word_number then
			if tag != "" then
				charpos += tag.length
				tag =~ /^<([!?\/]?)([^\s>]*)/
				close = $1
				name = $2
				if close == "/" then
					elementstack.pop
				elsif close == "" then
					if not (tag =~ /\/\s*>$/) then
						elementstack.push(name)
					end
				end
			end
		end
	end
	charpos
  end

end
