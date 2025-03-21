require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../options/ios_app'

module Fastlane
  module Actions
    class SqCiToolsGetBundleIdentifierAction < Action
      def self.run(params)
        project_path = params[:project_path]
        if project_path.nil? || project_path == ''
          UI.user_error!("Project path not specified!")
        end

        build_configuration = Helper::SqCiToolsHelper.get_xcodeproj_build_config(project_path, params[:main_target], params[:scheme])
        Helper::SqCiToolsHelper.resolve_recursive_build_setting(build_configuration, 'PRODUCT_BUNDLE_IDENTIFIER')
      end

      def self.description
        'Get bundle identifier of target for scheme from XCode project'
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
