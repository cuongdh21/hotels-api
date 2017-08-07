yml =  Rails.root.join('config', 'suppliers.yml')
SUPPLIER_LIST = {}

if File.exist?(yml)
	SUPPLIER_LIST = YAML.load_file(yml)
end
