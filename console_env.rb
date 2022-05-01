# Environment with utility methods for multipurpose ruby console

require 'cgi'
require 'csv'
require 'json'
require 'stringio'
require 'uri'

Proc.new do
  gems = %w[http mechanize nokogiri oj pry redis]
  begin
    gems.each { |g| require(g) }
  rescue LoadError
    puts 'Missing required gems. Install? (y/n)'
    answer = gets.chomp

    exit(1) if answer.strip != 'y'

    gems.each { |g| Gem.install(g) }
    Gem.clear_paths
    gems.each { |g| require(g) }
  end
end.call

$log = Logger.new(STDOUT)
$log.level = :info

$http = HTTP.use(logging: { logger: $log })

# File

def tmp_file(str)
  File.join(ENV['HOME'], 'tmp', str)
end

# JSON

# parse JSON string
def pjson(str)
  Oj.load(str)
end

# given file path, read file and parse JSON
def fjson(str)
  pjson(File.open(str))
end

# given filename in tmp, read file and parse JSON
def tjson(str)
  path = tmp_file(str)
  
  if File.exists?(path)
    fjson(path)
  else
    fjson(tmp_file("#{str}.json"))
  end
end

# Redis

def redis_conn(host = nil)
  Redis.new(host: host)
end

# Pry

def start_console(b)
  Pry.config.prompt = Pry::Prompt.new(
    'custom',
    'custom',
    [proc {' > '}, proc {' * '}]
  )
  b.pry(:quiet => true)
end
