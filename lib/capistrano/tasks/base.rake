def template(from, to, args)
  template_path = File.expand_path("../templates/#{from}", __FILE__)
  template = ERB.new(File.new(template_path).read).result(binding)
  upload! StringIO.new(template), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end