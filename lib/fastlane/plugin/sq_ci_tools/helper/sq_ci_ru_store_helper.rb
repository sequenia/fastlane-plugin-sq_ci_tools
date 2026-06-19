require 'digest'
require 'json'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class RuStoreHelper

      def self.get_token(key_id:, private_key:, timeout:)
        timestamp = DateTime.now.iso8601(3)
        signature = rsa_sign(timestamp, key_id, private_key)

        http = self.get_http(timeout: timeout)

        request = Net::HTTP::Post.new("/public/auth/")
        self.fill_headers(
          request: request
        )

        request.body = {
          keyId: key_id,
          timestamp: timestamp,
          signature: signature
        }.to_json
        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body["body"]["jwe"]
        else
          UI.user_error!("Unable to get RuStore token: #{response.message}, #{response.body}")
        end
      end

      def self.get_draft_id(token:, package_name:, timeout:)
        http = self.get_http(timeout: timeout)

        query_params = URI.encode_www_form({
          versionStatuses: "DRAFT"
        })

        request = Net::HTTP::Get.new("/public/v1/application/#{package_name}/version?#{query_params}")
        self.fill_headers(
          request: request,
          token: token
        )

        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          versions = json_body["body"]["content"]
          return versions.empty? ? nil : versions[0]["versionId"]
        else
          UI.user_error!("Unable to get RuStore application draft: #{response.message}, #{response.body}")
        end
      end

      def self.create_draft(
        token:,
        package_name:,
        changelog_path:,
        publish_type:, publish_date_time:,
        timeout:
      )
        http = self.get_http(timeout: timeout)

        request = Net::HTTP::Post.new("/public/v1/application/#{package_name}/version")
        self.fill_headers(
          request: request,
          token: token
        )

        changelog = ''
        unless changelog_path.nil?
          changelog_data = File.read(changelog_path)
          if changelog_data.length > 5000
            UI.user_error!("Файл 'Что нового?' содержит более 5000 символов")
            return
          else
            changelog = changelog_data
          end
        end

        request.body = {
          whatsNew: changelog,
          publishType: publish_type,
          publishDateTime: publish_date_time
        }.to_json

        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body["body"]
        else
          UI.user_error!("Unable to create RuStore application draft: #{response.message}, #{response.body}")
        end
      end

      def self.upload_aab(token:, package_name:, draft_id:, aab_path:, timeout:)
        http = self.get_http(timeout: timeout)
        request = Net::HTTP::Post.new("/public/v1/application/#{package_name}/version/#{draft_id}/aab")
        
        request.add_field('Public-Token', token)
        request.set_form([['file', File.open(aab_path)]], 'multipart/form-data')

        response = http.request(request)
        unless response.kind_of? Net::HTTPSuccess
          UI.user_error!("Unable to upload aab to RuStore application draft: #{response.message}, #{response.body}")
        end
      end

      def self.send_to_review(token:, package_name:, draft_id:, timeout:)
        http = self.get_http(timeout: timeout)
        request = Net::HTTP::Post.new("/public/v1/application/#{package_name}/version/#{draft_id}/commit")
        self.fill_headers(
          request: request,
          token: token
        )

        response = http.request(request)
        unless response.kind_of? Net::HTTPSuccess
          UI.user_error!("Unable send to review RuStore application draft: #{response.message}, #{response.body}")
        end
      end

      def self.get_http(timeout:)
        uri = URI.parse("https://public-api.rustore.ru")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = timeout
        http.set_debug_output($stdout)

        http
      end

      def self.fill_headers(request:, token: "", content_type: 'application/json')
        request.add_field('Content-Type', content_type)
        request.add_field('Public-Token', token)
      end

      def self.rsa_sign(timestamp, key_id, private_key)
        key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\n#{private_key}\n-----END RSA PRIVATE KEY-----")
        signature = key.sign(OpenSSL::Digest.new('SHA512'), key_id + timestamp)
        Base64.encode64(signature)
      end
    end
  end
end
