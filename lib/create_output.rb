def create_output(query)
	config = load_YAML("#{PATH}/schema/config_schema.yaml",
	                   "#{PATH}/conf/config.yaml")

	uri = create_uri(config[:database][:dbms],
	                 config[:database][:username],
	                 config[:database][:password],
	                 config[:database][:host],
	                 config[:database][:port],
	                 config[:database][:dbname]) 

	options = Hash.new
	options[:encoding] = config[:database][:encoding] unless config[:database][:encoding].blank?
	options[:socket] = config[:database][:socket] unless config[:database][:socket].blank?

	database = DBI.new(uri, options)
	output = database.execute(params[:query])
	database.close

	return output
end
