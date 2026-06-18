require 'fastlane/action'
require_relative '../helper/sq_ci_ru_store_helper'

module Fastlane
  module Actions

    class SqCiToolsRuStoreUploadAabAction < Action
      def self.run(params)
        token = params[:token]
        package_name = params[:package_name]
        aab_path = params[:aab_path]
        draft_id = params[:draft_id]
        timeout = params[:timeout]

        Helper::RuStoreHelper.upload_aab(
          token: token,
          package_name: package_name,
          aab_path: aab_path,
          draft_id: draft_id,
          timeout: timeout
        )
      end

      def self.description
        'Upload aab to RuStore\'s app draft'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :aab_path,
            description: 'Path to .aab-file',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :draft_id,
            description: 'Identifier of RuStore app draft',
            optional: false,
            type: String,
            default_value: Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SQ_CI_RU_STORE_DRAFT_ID],
            default_value_dynamic: true,
          )
        ] +
          Options::RuStore.options +
          Options::Shared.options
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
