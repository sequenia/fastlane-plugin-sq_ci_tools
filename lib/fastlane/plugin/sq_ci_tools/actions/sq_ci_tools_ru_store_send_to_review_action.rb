require 'fastlane/action'
require_relative '../helper/sq_ci_ru_store_helper'

module Fastlane
  module Actions

    class SqCiToolsRuStoreSendToReviewAction < Action
      def self.run(params)
        token = params[:token]
        package_name = params[:package_name]
        draft_id = params[:draft_id]
        timeout = params[:timeout]

        Helper::RuStoreHelper.send_to_review(
          token: token,
          package_name: package_name,
          draft_id: draft_id,
          timeout: timeout
        )
      end

      def self.description
        'Send app draft to RuStore\'s review'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :draft_id,
            description: 'Identifier of RuStore app draft',
            optional: false,
            type: String,
            default_value: Fastlane::Actions.lane_context[Fastlane::Actions::SharedValues::SQ_CI_RU_STORE_DRAFT_ID],
            default_value_dynamic: true
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
