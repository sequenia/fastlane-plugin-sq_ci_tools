require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require 'net/http/post/multipart'
require_relative '../../../../sq_ci_tools/telegram/options'

module Fastlane
  module Actions
    class SqCiToolsSendTelegramMessageAction < Action
      def self.run(params)
        access_token = params[:telegram_access_token]
        chat_ids = params[:telegram_chat_ids]
        if access_token.nil? || access_token == "" || chat_ids.nil? || chat_ids == ""
          return
        end

        uri = URI.parse("https://api.telegram.org/bot#{access_token}/sendMessage")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        chat_ids.split(',').each do |chat_id|
          request = Net::HTTP::Post::Multipart.new(uri, {
            "chat_id" => chat_id,
            "text" => params[:message],
            "parse_mode" => params[:parse_mode]
          })

          http.request(request)
        end
      end

      def self.description
        'Send message via telegram'
      end

      def self.details
        ''
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :message,
            description: 'Message for send',
            optional: false,
            type: String
          )
        ] +
          ::SqCiTools::Telegram::Options.options
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
