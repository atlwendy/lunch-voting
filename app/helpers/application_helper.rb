require 'bootstrap_extension'

module ApplicationHelper
  include BootstrapExtension

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
  	
  def gravatar_url(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  def pluralize_to_sentence(num)
		if num == 1
		  "#{num} person is going"
		else
		  "#{num} people are going"
		end
	end

  def flash_class(level)
    case level
      when "notice" then "alert alert-info"
      when "success" then "alert alert-success"
      when "error" then "alert alert-danger"
      when "alert" then "alert alert-danger"
      else "alert sowrong"
    end
end

  # Add the modified method to ApplicationHelper
  
end
