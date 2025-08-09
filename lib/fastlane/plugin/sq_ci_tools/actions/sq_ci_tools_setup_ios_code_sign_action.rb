require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../options/keychain'
require_relative '../options/ios_app'
require_relative '../options/code_signing'

module Fastlane
  module Actions
    class SqCiToolsSetupIosCodeSignAction < Action
      def self.run(params)
        other_action.sq_ci_tools_prepare_keychain

        ENV['MATCH_PASSWORD'] = params[:certificates_password]

        targets = Helper::SqCiToolsHelper.get_xcodeproj_targets(params[:project_path], params[:scheme])

        other_action.sync_code_signing(
          type: params[:code_signing_type],
          git_url: params[:certificates_repo],
          keychain_name: params[:keychain_name],
          keychain_password: params[:keychain_password],
          skip_confirmation: true,
          app_identifier: targets.map { |_, app_id| app_id },
          force: true,
          verbose: params[:verbose],
          generate_apple_certs: params[:generate_apple_certs]
        )

        targets.each do |target, app_identifier|
          Helper::SqCiToolsHelper.add_target_attributes(
            target_name: target,
            project_path: params[:project_path]
          )

          other_action.update_code_signing_settings(
            use_automatic_signing: false,
            path: params[:project_path],
            bundle_identifier: app_identifier,
            profile_name: lane_context[SharedValues::MATCH_PROVISIONING_PROFILE_MAPPING][app_identifier],
            code_sign_identity: params[:code_sign_identity],
            targets: [target],
            build_configurations: [params[:scheme]]
          )
        end
      end

      def self.description
        'Setup code sign of iOS application'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :scheme,
            description: 'Scheme for build',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :verbose,
            optional: true,
            type: Boolean,
            default_value: false
          ),
          FastlaneCore::ConfigItem.new(
            key: :generate_apple_certs,
            optional: true,
            type: Boolean,
            default_value: true
          )
        ] +
          Options::CodeSigning.options +
          Options::Keychain.options +
          Options::IosApp.options
      end

      def self.return_value
        ''
      end

      def self.authors
        ['Semen Kologrivov']
      end

      def self.is_supported?(_)
        true
      end
    end
  end
end
