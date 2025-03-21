require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module Fastlane
  module SqCiTools
    module Options
      class Shared
        def self.options
          [
            FastlaneCore::ConfigItem.new(
              key: :timeout,
              env_name: "SQ_CI_TIMEOUT",
              optional: true,
              description: "Timeout for read, open, and send (in seconds)",
              type: Integer,
              default_value: 300
            )
          ]
        end
      end
    end
  end
end