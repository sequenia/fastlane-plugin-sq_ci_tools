require 'fastlane_core/configuration/config_item'
require 'credentials_manager/appfile_config'

module SqCiTools
  module IosApp
    class Options
      def self.options
        [
          FastlaneCore::ConfigItem.new(
            key: :project_path,
            env_name: 'SQ_CI_PROJECT_PATH',
            description: 'Path to project',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :workspace_path,
            env_name: 'SQ_CI_WORKSPACE_PATH',
            description: 'Path to workspace',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :main_target,
            description: 'Name of main target',
            env_name: 'SQ_CI_MAIN_TARGET',
            optional: true,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :export_method,
            env_name: 'SQ_CI_EXPORT_METHOD',
            description: 'Export method for build',
            optional: true,
            type: String,
            default_value: "app-store"
          ),
          FastlaneCore::ConfigItem.new(
            key: :build_args,
            env_name: 'SQ_CI_BUILD_ARGS',
            description: 'Additional args for project build',
            optional: true,
            type: String,
            default_value: "-skipPackagePluginValidation -skipMacroValidation -allowProvisioningUpdates"
          ),
          FastlaneCore::ConfigItem.new(
            key: :should_clear_project,
            env_name: 'SQ_CI_SHOULD_CLEAR_PROJECT',
            description: 'Should clear project before build',
            optional: true,
            default_value: true
          ),
          FastlaneCore::ConfigItem.new(
            key: :derived_data_path,
            env_name: 'SQ_CI_DERIVED_DATA_PATH',
            description: 'Path to derived data folder',
            optional: true,
            type: String
          )
        ]
      end
    end
  end
end
