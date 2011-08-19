module E9Attributes::Model
  extend ActiveSupport::Concern

  module ClassMethods
    def has_record_attributes(*attributes)
      options = attributes.extract_options!

      class_inheritable_accessor :record_attributes
      self.record_attributes = attributes.flatten.map do |a|
        a = a.to_s.classify
        a = a =~ /Attribute$/ ? a : "#{a}Attribute"
        a.constantize rescue next
        a.underscore.pluralize
      end.compact

      has_many :record_attributes, :as => :record

      self.record_attributes.each do |association_name|
        has_many association_name.to_sym, :class_name => association_name.classify, :as => :record
        accepts_nested_attributes_for association_name.to_sym, :allow_destroy => true, :reject_if => :reject_record_attribute?
      end
    end
  end

  def build_all_record_attributes
    record_attributes.each do |attr|
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
