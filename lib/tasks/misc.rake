task :default do
  Dir["test/**/*.rb"].sort.each { |test|  load test }
end
