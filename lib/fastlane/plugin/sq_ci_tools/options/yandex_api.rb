require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'fastlane_core/configuration/config_item'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Options
    class YandexApi
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :iam_token,
            env_name: 'SQ_CI_YANDEX_API_IAM_TOKEN',
            description: 'IAM token for Yandex API',
            optional: false,
            type: String,
            default_value: Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SQ_CI_YANDEX_API_IAM_TOKEN],
            default_value_dynamic: true,
          )
        ]
      end
    end
  end
end