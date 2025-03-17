https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/Cookies

som en header i response:
Set-Cookie: <cookie-name>=<cookie-value>

dvs

str = ""
hash.each do |item|
	str << "Set-Cookie: <#{item.id}>=<item[item.id]>\n"
end