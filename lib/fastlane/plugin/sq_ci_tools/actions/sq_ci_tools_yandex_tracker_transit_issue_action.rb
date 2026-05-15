require 'fastlane/action'
require_relative '../helper/sq_ci_tools_yandex_tracker_helper'
require_relative '../options/yandex_api'
require_relative '../options/yandex_tracker'

module Fastlane
  module Actions

    class SqCiToolsYandexTrackerTransitIssueAction < Action
      def self.run(params)
        Helper::SqCiToolsYandexTrackerHelper.transit_issue(
          issue_id: params[:issue_id],
          transition_name: params[:transition_name],
          organization_id: params[:organization_id],
          iam_token: params[:iam_token]
        )
      end

      def self.description
        'Transit issue to the new status'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :issue_id,
            description: 'Id of issue',
            optional: false,
            type: String,
          ),
          FastlaneCore::ConfigItem.new(
            key: :transition_name,
            description: 'Name of transition',
            optional: false,
            type: String,
          )
        ] + Options::YandexApi.options + Options::YandexTracker.options
      end

      def self.return_type
        :hash
      end

      def self.return_value
        'Updated issue'
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
