require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../../../../sq_ci_tools/keychain/options'
require_relative '../../../../sq_ci_tools/ios_app/options'
require_relative '../../../../sq_ci_tools/code_signing/options'

module Fastlane
  module Actions
    class SqCiToolsBuildIosApplicationAction < Action
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

        project_path = params[:project_path]
        workspace_path = params[:workspace_path]
        derived_data_path = params[:derived_data_path]

        ENV['FASTLANE_XCODEBUILD_SETTINGS_RETRIES'] = "10"
        ENV['FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT'] = "300"
        ENV['FASTLANE_XCODE_LIST_TIMEOUT'] = "300"

        if !workspace_path.nil? && workspace_path != ''
          ENV['GYM_WORKSPACE'] = workspace_path
        elsif !project_path.nil? && project_path != ''
          ENV['GYM_PROJECT'] = project_path
        end

        if !derived_data_path.nil? && derived_data_path != ''
          ENV['GYM_DERIVED_DATA_PATH'] = derived_data_path
        end

        latest_build_number = other_action.latest_testflight_build_number(
          initial_build_number: 0
        )

        other_action.increment_build_number(
          build_number: latest_build_number + 1,
          xcodeproj: params[:project_path],
          skip_info_plist: true
        )

        other_action.build_app(
          clean: params[:should_clear_project],
          scheme: params[:scheme],
          export_method: params[:export_method],
          xcargs: params[:build_args]
        )
      end

      def self.description
        'Generate new build of iOS application (includes updating of code signing)'
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
          ::SqCiTools::CodeSigning::Options.options +
          ::SqCiTools::Keychain::Options.options +
          ::SqCiTools::IosApp::Options.options
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
