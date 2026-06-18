require 'fastlane/action'
require_relative '../helper/sq_ci_ru_store_helper'

module Fastlane
  module Actions

    module SharedValues
      SQ_CI_RU_STORE_DRAFT_ID = :SQ_CI_RU_STORE_DRAFT_ID
    end

    class SqCiToolsRuStoreFindOrCreateDraftIdAction < Action
      def self.run(params)
        token = params[:token]
        package_name = params[:package_name]
        changelog_path = params[:changelog_path]
        publish_type = params[:publish_type]
        publish_date_time = params[:publish_date_time]
        timeout = params[:timeout]

        draft_id = Helper::RuStoreHelper.get_draft_id(
          token: token,
          package_name: package_name,
          timeout: timeout
        )

        if draft_id.nil?
          draft_id = Helper::RuStoreHelper.create_draft(
            token: token,
            package_name: package_name,
            changelog_path: changelog_path,
            publish_type: publish_type,
            publish_date_time: publish_date_time,
            timeout: timeout
          )
        end

        lane_context[SharedValues::SQ_CI_RU_STORE_DRAFT_ID] = draft_id
        return draft_id
      end

      def self.description
        'Find or create draft id for passed application in RuStore'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :changelog_path,
            env_name: 'SQ_CI_RU_STORE_CHANGELOG_PATH',
            description: 'Path to .txt-file with version\'s changelog',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :publish_type,
            env_name: 'SQ_CI_RU_STORE_PUBLISH_TYPE',
            description: 'Version\'s publish type. Available values: MANUAL, INSTANTLY, DELAYED',
            optional: true,
            type: String,
            default_value: 'INSTANTLY'
          ),
          FastlaneCore::ConfigItem.new(
            key: :publish_date_time,
            env_name: 'SQ_CI_RU_STORE_PUBLISH_DATE_TIME',
            description: 'Version\'s publish datetime in format yyyy-MM-dd\'T\'HH:mm:ssXXX. Required for DELAYED publish type',
            optional: true,
            type: String,
            default_value: ''
          )
        ] +
          Options::RuStore.options +
          Options::Shared.options
      end

      def self.return_type
        :integer
      end

      def self.return_value
        'Draft identifier'
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
