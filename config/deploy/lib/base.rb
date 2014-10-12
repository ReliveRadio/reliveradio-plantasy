require 'securerandom' # for password generation

# evaluate template erb files in templates folder and upload them
# to the server
def my_template(template_name)
	config_file = "#{fetch(:templates_path)}/#{template_name}"
	StringIO.new(ERB.new(File.read(config_file)).result(binding))
end

def sudo_upload!(from, to)
	filename = File.basename(to)
	to_dir = File.dirname(to)
	tmp_file = "#{fetch(:tmp_dir)}/#{filename}"
	upload! from, tmp_file
	sudo :mv, tmp_file, to_dir
end

def generate_password
	SecureRandom.hex(20)
end