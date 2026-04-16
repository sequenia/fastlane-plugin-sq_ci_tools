require 'fastlane/action'
require 'net/http'
require 'json'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../options/max'

module Fastlane
  module Actions
    class SqCiToolsSendMaxMessageAction < Action
      def self.run(params)
        access_token = params[:max_access_token]
        chat_ids = params[:max_chat_ids]
        if access_token.nil? || access_token == "" || chat_ids.nil? || chat_ids == ""
          return
        end
        puts params

        chat_ids.split(',').each do |chat_id|
          uri = URI.parse("https://platform-api.max.ru")

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.set_debug_output($stdout)

          request = Net::HTTP::Post.new("/messages?chat_id=#{chat_id}")
          request.add_field('Content-Type', 'application/json')
          request.add_field('Authorization', access_token)
          request.body = {
            "text" => params[:message],
            "format" => params[:max_format]
          }.to_json
          response = http.request(request)

          puts response
          puts response.message
          puts response.body
        end
      end

      def self.description
        'Send message via Max'
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
          Options::Max.options
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
