module UsersHelper
  def gravatar_for user, size: Settings.avata_size
    gravatar_id = Digest::MD5::hexdigest(current_user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: current_user.name, class: "gravatar"
  end

  def unfollow
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
