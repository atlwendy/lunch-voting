module ApplicationHelper

	def avatar_url(user)
	  if user.avatar_url.present?
	    user.avatar_url
	  else
	    default_url = "#{Rails.root}/app/assets/images/guest.png"
	    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
	    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
	  end
	end

	def gravatar_for(user)
  	  gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
  	  gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  	  image_tag(gravatar_url, alt: user.username, class: "gravatar")
  	end

end
