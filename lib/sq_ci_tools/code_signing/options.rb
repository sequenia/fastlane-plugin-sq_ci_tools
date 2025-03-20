require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCiTools
  module CodeSigning
    class Options
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :code_signing_type,
            env_name: 'SQ_CI_CODE_SIGNING_TYPE',
            description: 'Targets in project',
            optional: true,
            type: String,
            default_value: 'appstore'
          ),
          FastlaneCore::ConfigItem.new(
            key: :code_sign_identity,
            env_name: 'SQ_CI_CODE_SIGN_IDENTITY',
            description: 'Code sign identity for profile',
            optional: true,
            type: String,
            default_value: 'iPhone Distribution'
          ),
          FastlaneCore::ConfigItem.new(
            key: :certificates_repo,
            env_name: 'SQ_CI_CERTIFICATES_REPO',
            description: 'Repository for store certificates and profiles',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :certificates_password,
            env_name: 'SQ_CI_CERTIFICATES_PASSWORD',
            description: 'Password for certificates and profiles storage',
            optional: false,
            type: String
          )
        ]
      end
    end
  end
end
