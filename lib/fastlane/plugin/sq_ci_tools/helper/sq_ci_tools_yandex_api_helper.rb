require 'fastlane/action'
require 'fastlane_core/ui/ui'

require 'jwt'
require 'json'
require 'time'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class SqCiToolsYandexApiHelper
    
      def self.get_iam_token(keys_file_path:)
        uri = URI.parse("https://iam.api.cloud.yandex.net")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.set_debug_output($stdout)

        request = Net::HTTP::Post.new("/iam/v1/tokens")
        request.add_field('Content-Type', 'application/json')
        request.body = {
          "jwt" => self.generate_jwt(keys_file_path)
        }.to_json
        response = http.request(request)

        if response.kind_of? Net::HTTPSuccess
          json_body = JSON.parse(response.body)
          return json_body["iamToken"]
        else
          UI.user_error!("Unable to fetch Yandex API IAM Token: #{response.message}, #{response.body}")
        end
      end

      private

      def self.generate_jwt(keys_file_path)
        key_file_content = JSON.parse(File.read(keys_file_path))
        
        self.signed_token(key_file_content)
      end

      def self.signed_token(key_file_content)
        service_account_id = key_file_content['service_account_id']
        key_id = key_file_content['id']

        payload = {
          iss: service_account_id,
          exp: Time.now.to_i + 3600,
          iat: Time.now.to_i,
          nbf: Time.now.to_i,
          aud: "https://iam.api.cloud.yandex.net/iam/v1/tokens"
        }

        header = {
          kid: key_id
        }

        private_key = self.load_private_key(key_file_content)

        JWT.encode(payload, private_key, 'PS256', header)
      end

      def self.load_private_key(key_file_content)
        OpenSSL::PKey::RSA.new(key_file_content['private_key'])
      rescue IOError, JSON::ParserError, OpenSSL::PKey::RSAError => e
        raise "Failed to load or parse private key: #{e.message}"
      end
    end
  end
end
