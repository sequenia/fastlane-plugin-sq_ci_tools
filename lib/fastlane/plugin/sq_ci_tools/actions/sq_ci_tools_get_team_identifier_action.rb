require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../../../../sq_ci_tools/ios_app/options'

module Fastlane
  module Actions
    class SqCiToolsGetTeamIdentifierAction < Action
      def self.run(params)
        project_path = params[:project_path]
        if project_path.nil? || project_path == ''
          UI.user_error!("Project path not specified!")
        end

        build_configuration = Helper::SqCiToolsHelper.get_xcodeproj_build_config(project_path, params[:main_target], params[:scheme])
        Helper::SqCiToolsHelper.resolve_recursive_build_setting(build_configuration, 'DEVELOPMENT_TEAM')
      end

      def self.description
        'Get team identifier of target for scheme from XCode project'
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
