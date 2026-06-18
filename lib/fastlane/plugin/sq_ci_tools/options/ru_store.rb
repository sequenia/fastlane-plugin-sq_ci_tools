require 'fastlane/action'
require 'fastlane_core/ui/ui'
require 'fastlane_core/configuration/config_item'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Options
    class RuStore
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :token,
            env_name: 'SQ_CI_RU_STORE_TOKEN',
            description: 'Token  for RuStore\'s API',
            optional: false,
            type: String,
            default_value: Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SQ_CI_RU_STORE_TOKEN],
            default_value_dynamic: true,
          ),
          FastlaneCore::ConfigItem.new(
            key: :package_name,
            env_name: 'SQ_CI_RU_STORE_PACKAGE_NAME',
            description: 'Package name of RuStore application',
            optional: false,
            type: String,
            default_value: CredentialsManager::AppfileConfig.try_fetch_value(:package_name),
            default_value_dynamic: true,
          )
        ]
      end
    end
  end
end