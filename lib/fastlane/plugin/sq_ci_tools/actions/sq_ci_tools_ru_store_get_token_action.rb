require 'fastlane/action'
require_relative '../helper/sq_ci_ru_store_helper'

module Fastlane
  module Actions
    module SharedValues
      SQ_CI_RU_STORE_TOKEN = :SQ_CI_RU_STORE_TOKEN
    end

    class SqCiToolsRuStoreGetTokenAction < Action
      def self.run(params)
        key_id = params[:key_id]
        private_key = params[:private_key]
        timeout = params[:timeout]
        token = Helper::RuStoreHelper.get_token(
          key_id: key_id,
          private_key: private_key,
          timeout: timeout
        )

        lane_context[SharedValues::SQ_CI_RU_STORE_TOKEN] = token
        return token
      end

      def self.description
        'Fetch token for RuStore API'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :key_id,
            env_name: 'SQ_CI_RU_STORE_KEY_ID',
            description: 'Identifier of RuStore\'s API key',
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :private_key,
            env_name: 'SQ_CI_RU_STORE_PRIVATE_KEY',
            description: 'Private key for RuStore\'s API key',
            optional: false,
            type: String
          )
        ] + Options::Shared.options
      end

      def self.return_type
        :string
      end

      def self.return_value
        'RuStore API Token'
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
