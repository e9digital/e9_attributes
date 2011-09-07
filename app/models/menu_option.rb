# A simple class to manage menu options, usable by other classes to build their menus.
#
class MenuOption < ActiveRecord::Base
  cattr_writer :keys

  def self.keys
    @@keys || []
  end

  validates :value, :presence  => true
  validate { errors.add(:key, :inclusion) if key.present? && !keys.include?(key) }

  acts_as_list :scope => 'menu_options.key = \"#{key}\"'

  scope :options_for, lambda {|key| where(:key => key).order('menu_options.position ASC') }

  delegate :keys, :to => 'self.class'

  ##
  # A direct SQL selection of values for a given key
  #
  #   MenuOption.fetch('Email') #=> ['Personal','Work']
  #
  # === Parameters
  #
  # [key (String)] The key for the assocated menu options.
  #
  def self.fetch_values(key)
    connection.send(:select_values, options_for(key).select('value').order(:position).to_sql, 'Menu Option Select')
  end

  def to_s
    value
  end

  # For e9 admin
  def role; 'administrator' end
end
