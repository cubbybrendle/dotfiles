# Environment with utility methods for multipurpose ruby console

require 'json'
require 'cgi'
require 'uri'
require 'stringio'

require 'oj'
require 'rest-client'
require 'mechanize'
require 'nokogiri'
require 'redis'

# Swallow up some warnings printed during pry load
orig_stderr, $stderr = $stderr, StringIO.new
require 'pry'
$stderr = orig_stderr

$log = Logger.new(STDOUT)
RestClient.log = $log

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
  Pry.config.prompt = [proc{' > '}, proc{' * '}]
  b.pry(:quiet => true)
end
