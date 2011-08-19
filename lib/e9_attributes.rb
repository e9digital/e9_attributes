require "rails"
require "e9_base"
require "e9_attributes/version"

module E9Attributes
  autoload :VERSION, 'e9_attributes/version'
  autoload :Model,   'e9_attributes/model'

  def E9Attributes.init!
    ActiveRecord::Base.send(:include, E9Attributes::Model)
  end

  class Engine < ::Rails::Engine
    config.e9_attributes = E9Attributes
    config.to_prepare { E9Attributes.init! }

    initializer 'e9_attributes.include_base_helper' do
      ActiveSupport.on_load(:action_view) do
        require 'e9_attributes/helper'
        include E9Attributes::Helper
      end
    end
  end
end
