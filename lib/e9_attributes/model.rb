module E9Attributes::Model
  extend ActiveSupport::Concern

  module ClassMethods
    #
    # By default, it reformats the attributes passed into association
    # names and defines them.  To add a record attribute without defining
    # an association name, pass the association names literally and specify
    # the option :skip_name_format. This will cause the method to skip adding
    # associations for any attribute not ending in "_attributes", which you
    # must add manually, e.g.
    #
    #     has_many :users
    #     accepts_nested_attributes_for :users, :allow_destroy => true
    #
    def has_record_attributes(*attributes)
      options = attributes.extract_options!
      options.symbolize_keys!

      class_inheritable_accessor :record_attributes

      attributes.flatten!
      attributes.map!(&:to_s)

      unless options[:skip_name_format]
        attributes.map! do |a|
          a = a.classify
          a = a =~ /Attribute$/ ? a : "#{a}Attribute"
          a.constantize rescue next
          a.underscore.pluralize
        end.compact
      end

      self.record_attributes = attributes

      has_many :record_attributes, :as => :record

      self.record_attributes.select {|r| r =~ /attributes$/ }.each do |association_name|
        has_many association_name.to_sym, :class_name => association_name.classify, :as => :record
        accepts_nested_attributes_for association_name.to_sym, :allow_destroy => true, :reject_if => :reject_record_attribute?
      end
    end
  end

  def build_all_record_attributes
    self.class.record_attributes.each do |attr|
      params_method = "#{attr}_build_parameters"
      build_params = self.class.send(params_method) if self.class.respond_to?(params_method)
      send(attr).send(:build, build_params || {})
    end
  end

  protected

    def reject_record_attribute?(attributes)
      attributes.keys.member?('value') && attributes['value'].blank?
    end

end
