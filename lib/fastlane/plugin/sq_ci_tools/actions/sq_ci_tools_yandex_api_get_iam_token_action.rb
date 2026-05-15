require 'fastlane/action'
require_relative '../helper/sq_ci_tools_yandex_api_helper'

module Fastlane
  module Actions
    module SharedValues
      SQ_CI_YANDEX_API_IAM_TOKEN = :SQ_CI_YANDEX_API_IAM_TOKEN
    end

    class SqCiToolsYandexApiGetIamTokenAction < Action
      def self.run(params)
        keys_file_path = params[:keys_file_path]
        iam_token = Helper::SqCiToolsYandexApiHelper.get_iam_token(
          keys_file_path: keys_file_path
        )

        lane_context[SharedValues::SQ_CI_YANDEX_API_IAM_TOKEN] = iam_token
        return iam_token
      end

      def self.description
        'Fetch Yandex API IAM-token'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :keys_file_path,
            env_name: 'SQ_CI_YANDEX_API_KEY_FILE_PATH',
            description: 'File with keys of Yandex\'s Service account',
            optional: false,
            type: String
          )
        ]
      end

      def self.return_type
        :string
      end

      def self.return_value
        'Yandex API IAM-token'
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
