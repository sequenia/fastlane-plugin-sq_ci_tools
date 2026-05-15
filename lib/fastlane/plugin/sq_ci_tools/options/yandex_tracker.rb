require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'fastlane_core/configuration/config_item'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Options
    class YandexTracker
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :organization_id,
            env_name: 'SQ_CI_YANDEX_TRACKER_ORGANIZATION_ID',
            description: 'Organization id in Yandex cloud',
            optional: false,
            type: String,
          )
        ]
      end
    end
  end
end