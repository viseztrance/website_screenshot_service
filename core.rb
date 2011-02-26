require "rubygems"
require "sinatra"
require "uuid"
require "yaml"

SINATRA_ROOT = File.dirname(__FILE__)

if Sinatra::Application.environment.to_s == "production"
  ENV["QTWEBKIT_PLUGIN_PATH"] = File.join(SINATRA_ROOT, "plugins")
end

before do
  keys = YAML.load_file(File.join(SINATRA_ROOT, "keys.yml"))[Sinatra::Application.environment.to_s]
  halt 401, "Invalid key" unless keys.include?(params[:key])
end

get "/" do
  file_name = File.join(SINATRA_ROOT, "tmp", UUID.generate + ".png")
  size = params[:size] || "1400x900"
  launcher = "website-screenshot"
  if Sinatra::Application.environment.to_s == "production"
    launcher << 'xvfb-run --server-args="-screen 0, %sx24"' % size
  end
  `#{launcher} --url=#{params[:url]} --file=#{file_name} --size=#{size}`
  if File.exists?(file_name)
    data = File.read(file_name)
    File.delete(file_name) # cleanup
    content_type "image/png"
    data
  else
    halt 404, "Location could not be opened"
  end
end
