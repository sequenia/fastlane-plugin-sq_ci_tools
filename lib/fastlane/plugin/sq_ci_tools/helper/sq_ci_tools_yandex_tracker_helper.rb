require 'fastlane/action'
require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)
  HOST = 'api.tracker.yandex.net'

  module Helper
    class SqCiToolsYandexTrackerHelper
    
      def self.find_issues(query:, body:, iam_token:, organization_id:)
        http = self.get_http

        query_params = URI.encode_www_form(query)
        request = Net::HTTP::Post.new("/v3/issues/_search?#{query_params}")
        self.fill_headers(
          request: request,
          iam_token: iam_token,
          organization_id: organization_id
        )

        request.body = body.to_json
        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body
        else
          UI.user_error!("Unable to fetch Yandex Tracker issues: #{response.message}, #{response.body}")
        end
      end

      def self.create_issue(query:, body:, iam_token:, organization_id:)
        http = self.get_http

        query_params = URI.encode_www_form(query)
        request = Net::HTTP::Post.new("/v3/issues?#{query_params}")
        self.fill_headers(
          request: request,
          iam_token: iam_token,
          organization_id: organization_id
        )

        request.body = body.to_json
        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body
        else
          UI.user_error!("Unable to fetch Yandex Tracker issues: #{response.message}, #{response.body}")
        end
      end


      def self.update_issue(query:, issue_id:, body:, iam_token:, organization_id:)
        http = self.get_http

        query_params = URI.encode_www_form(query)
        request = Net::HTTP::Patch.new("/v3/issues/#{issue_id}?#{query_params}")
        self.fill_headers(
          request: request,
          iam_token: iam_token,
          organization_id: organization_id
        )

        request.body = body.to_json
        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body
        else
          UI.user_error!("Unable to fetch Yandex Tracker issues: #{response.message}, #{response.body}")
        end
      end

      def self.transit_issue(issue_id:, transition_name:, iam_token:, organization_id:)
        http = self.get_http

        request = Net::HTTP::Post.new("/v3/issues/#{issue_id}/transitions/#{transition_name}/_execute")
        self.fill_headers(
          request: request,
          iam_token: iam_token,
          organization_id: organization_id
        )

        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body
        else
          UI.user_error!("Unable to fetch Yandex Tracker issues: #{response.message}, #{response.body}")
        end
      end

      private

      def self.get_http
        uri = URI.parse("https://#{HOST}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.set_debug_output($stdout)

        http
      end

      def self.fill_headers(request:, iam_token:, organization_id:)
        request.add_field('Content-Type', 'application/json')
        request.add_field('Host', HOST)
        request.add_field('Authorization', "Bearer #{iam_token}")
        request.add_field('X-Cloud-Org-ID', organization_id)
      end
    end
  end
end
