require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Options
    class Max
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :max_access_token,
            env_name: 'SQ_CI_MAX_ACCESS_TOKEN',
            description: 'Access token for Max bot',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :max_chat_ids,
            env_name: 'SQ_CI_MAX_CHAT_IDS',
            description: 'Max\'s chat ids for send message',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :max_format,
            env_name: 'SQ_CI_MAX_FORMAT',
            description: 'Max\'s format of message',
            optional: true,
            type: String,
            default_value: "markdown"
          )
        ]
      end
    end
  end
end