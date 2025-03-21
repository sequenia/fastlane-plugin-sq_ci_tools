require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module Fastlane
  module SqCiTools
    module Options
      class Telegram
        def self.options
          [
            FastlaneCore::ConfigItem.new(
              key: :telegram_access_token,
              env_name: 'SQ_CI_TELEGRAM_ACCESS_TOKEN',
              description: 'Access token for Telegram bot',
              optional: true,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :telegram_chat_ids,
              env_name: 'SQ_CI_TELEGRAM_CHAT_IDS',
              description: 'Telegram\'s chat ids for send message',
              optional: true,
              type: String
            ),
            FastlaneCore::ConfigItem.new(
              key: :parse_mode,
              env_name: 'SQ_CI_TELEGRAM_PARSE_MODE',
              description: 'Telegram\'s parse mode',
              optional: true,
              type: String,
              default_value: "Markdown"
            )
          ]
        end
      end
    end
  end
end