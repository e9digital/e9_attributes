# An arbitrary 'attribute' attachable to records.  
#
# Gets support for arbitrary options via InheritableOptions.  By default it 
# has one option, +type+, but subclasses could extend for further options by
# overwriting +options_parameters+.
#
# By default, the +type+ options are managed via the +MenuOption+ class.
#
class RecordAttribute < ActiveRecord::Base
  include E9Rails::ActiveRecord::STI
  include E9Rails::ActiveRecord::AttributeSearchable
  include E9Rails::ActiveRecord::InheritableOptions

  PARTIAL_PATH   = 'e9_attributes/record_attributes'
  FORM_PARTIAL   = PARTIAL_PATH + '/form_partial'
  LAYOUT_PARTIAL = PARTIAL_PATH + '/record_attribute'
  TEMPLATES      = PARTIAL_PATH + '/templates'
  
  self.options_parameters = [:type]
  self.delegate_options_methods = true

  belongs_to :record, :polymorphic => true

  scope :search, lambda {|query|
    where(arel_table[:value].matches('%query%'))
  }

  ##
  # Looks up the available +types+ for this attribute by fetching a 
  # titleized version of the class name from +MenuOption+.
  #
  # e.g.
  #   
  #   PhoneNumberAttribute.types
  #
  # is equivalent to:
  #
  #   MenuOption.fetch_values('Phone Number')
  #
  def self.types
    if name =~ /^(\w+)Attribute$/ 
      MenuOption.fetch_values($1.titleize)
    else 
      []
    end
  end

  def to_s
    options.type ? "#{value} (#{options.type})" : value
  end
end
