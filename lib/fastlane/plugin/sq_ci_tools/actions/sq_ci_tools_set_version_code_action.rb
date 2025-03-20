require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../../../../sq_ci_tools/android_app/options'

module Fastlane
  module Actions
    class SqCiToolsSetVersionCodeAction < Action
      def self.run(params)
        gradle_file_path = Helper::SqCiToolsHelper.get_gradle_file_path(params[:gradle_file_path])
        new_version_code = Helper::SqCiToolsHelper.get_new_version_code(gradle_file_path, params[:version_code])

        Helper::SqCiToolsHelper.save_key_to_gradle_file(gradle_file_path, "versionCode", new_version_code)
      end

      def self.description
        'Set version code for Android application'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :version_code,
            description: 'Version code to set',
            optional: false,
            type: String
          )
        ] +
          ::SqCiTools::AndroidApp::Options.options
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
