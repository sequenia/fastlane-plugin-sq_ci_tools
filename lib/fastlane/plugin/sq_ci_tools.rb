require 'fastlane/plugin/sq_ci_tools/version'

module Fastlane
  module SqCiTools
    # Return all .rb files inside the "actions", "helper" and "options" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper,options}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::SqCiTools.all_classes.each do |current|
  require current
end
