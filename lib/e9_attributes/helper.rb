module E9Attributes::Helper

  def link_to_add_record_attribute(association_name)
    content_tag :span, t(:add_record_attribute, :scope => :e9_attributes), :class => 'add-nested-association', 'data-association' => association_name
  end

  def link_to_destroy_record_attribute
    content_tag :span, t(:destroy_record_attribute, :scope => :e9_attributes), :class => 'destroy-nested-association'
  end

  def render_record_attribute_form(association_name, form)
    render(RecordAttribute::FORM_PARTIAL, {
      :form             => form,
      :association_name => association_name
    })
  end

  def render_record_attribute_association(association_name, form, options = {})
    options.symbolize_keys!

    association = resource.send(association_name)

    unless association.empty?
      form.fields_for(association_name) do |f|
        concat record_attribute_template(association_name, f, options)
      end
    end
  end

  def record_attribute_template(association_name, builder, options = {})
    options.symbolize_keys!

    render(
      :partial => options[:partial] || "record_attributes/#{association_name.to_s.singularize}",
      :locals => { :f => builder }
    )
  end

  # tries to build an associated resource, looking to the assocatiaon's model for a method
  # named "%{association_name}_build_parameters}" first for any default params
  def build_associated_resource(association_name)
    params_method = "#{association_name}_build_parameters"
    build_params = resource_class.send(params_method) if resource_class.respond_to?(params_method)
    resource.send(association_name).build(build_params || {})
  end
end
