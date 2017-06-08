require 'thor'
require 'rainbow'
require 'yaml'

require 'rainbow/version'
require 'rainbow/ext/string' unless Rainbow::VERSION < '2.0.0'

module Gearship
  autoload :Cli,        'gearship/cli'
  autoload :Logger,     'gearship/logger'
  autoload :Utility,    'gearship/utility'
end
