require 'fastlane/action'
require_relative '../helper/sq_ci_tools_helper'
require_relative '../options/keychain'

module Fastlane
  module Actions
    class SqCiToolsPrepareKeychainAction < Action
      def self.run(params)
        keychain_path = "~/Library/Keychains/#{params[:keychain_name]}-db"

        if `find ~/Library/Keychains -type f -print | grep '#{params[:keychain_name]}'`.strip.empty?
          other_action.create_keychain(
            lock_when_sleeps: false,
            name: params[:keychain_name],
            password: params[:keychain_password]
          )
        end

        other_action.unlock_keychain(
          path: keychain_path,
          password: params[:keychain_password]
        )
      end

      def self.description
        'Create in need and unblock keychain for iOS certificates'
      end

      def self.details
        ''
      end

      def self.available_options
        Options::Keychain.options
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
