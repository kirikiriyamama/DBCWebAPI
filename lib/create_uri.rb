def create_uri(scheme, username, password, host, port, path)
	return nil if(scheme.blank?)

	uri = "#{scheme}://"
	uri << "#{username}:#{password}" unless (username.blank? || password.blank?)
	host = 'localhost' if ((scheme == 'mysql' || scheme == 'postgres') && host.blank?)
	uri << "@#{host}" unless host.blank?
	uri << ":#{port}" unless (host.blank? || port.blank?)
	uri << "/"
	uri << "#{path}" unless path.blank?

	return uri
end
