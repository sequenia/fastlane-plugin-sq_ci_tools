require 'fastlane/action'
require_relative '../helper/sq_ci_tools_yandex_tracker_helper'
require_relative '../options/yandex_api'
require_relative '../options/yandex_tracker'

module Fastlane
  module Actions

    class SqCiToolsYandexTrackerFindIssuesAction < Action
      def self.run(params)
        Helper::SqCiToolsYandexTrackerHelper.find_issues(
          query: params[:query],
          body: params[:body],
          organization_id: params[:organization_id],
          iam_token: params[:iam_token]
        )
      end

      def self.description
        'Fetch Yandex tracker issues by passed query'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :query,
            description: 'Query params for find issues',
            optional: true,
            default_value: {},
            type: Hash,
          ),
          FastlaneCore::ConfigItem.new(
            key: :body,
            description: 'Body for find issues request',
            optional: true,
            default_value: {},
            type: Hash,
          )
        ] + Options::YandexApi.options + Options::YandexTracker.options
      end

      def self.return_type
        :array
      end

      def self.return_value
        'Array of tasks'
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
