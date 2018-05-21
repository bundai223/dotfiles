#require "itamae/resource/base"
#require "shellwords"

module ::MItamae
  module Plugin
    module Resource
      class Yaourt < ::MItamae::Resource::Base
        define_attribute :action, default: :install
        define_attribute :name, type: String, default_name: true
        define_attribute :version, type: String
        define_attribute :options, type: String
        define_attribute :user, type: String

      end
    end
  end
end
