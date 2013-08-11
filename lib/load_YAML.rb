def load_YAML(schema_file, document_file)
  schema = YAML.load_file(schema_file) rescue (raise 'Can\'t load the schema of config file')
  validator = Kwalify::Validator.new(schema)

  parser = Kwalify::Yaml::Parser.new(validator)
  document = parser.parse_file(document_file) rescue (raise 'Can\'t load the config file')

  errors = parser.errors
  if errors && !errors.empty? then
    raise 'There is an error in the config file'
  end

  document.symbolize_keys
end
