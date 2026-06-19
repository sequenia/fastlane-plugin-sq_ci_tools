require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../options/keychain'
require_relative '../options/ios_app'
require_relative '../options/code_signing'

module Fastlane
  module Actions
    class SqCiToolsBuildIosApplicationAction < Action
      def self.run(params)

        timeout = params["timeout"]
        project_path = params[:project_path]
        workspace_path = params[:workspace_path]
        derived_data_path = params[:derived_data_path]

        ENV['FASTLANE_XCODEBUILD_SETTINGS_RETRIES'] = "10"
        ENV['FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT'] = timeout
        ENV['FASTLANE_XCODE_LIST_TIMEOUT'] = timeout

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
        'Generate new build of iOS application'
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
          )
        ] +
          Options::CodeSigning.options +
          Options::Keychain.options +
          Options::IosApp.options +
          Options::Shared.options
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
