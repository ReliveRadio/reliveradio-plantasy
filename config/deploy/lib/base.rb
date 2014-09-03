# evaluate template erb files in templates folder and upload them
# to the server
def template(from, to)
  template_path = File.expand_path("../../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to
end