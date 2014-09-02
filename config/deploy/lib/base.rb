
# evaluate template erb files in templates folder and upload them
# to the server
def template(from, to)
  erb = File.read(File.expand_path("../../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end
