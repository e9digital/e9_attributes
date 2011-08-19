# A simple class to manage menu options, usable by other classes to build their menus.
#
class MenuOption < ActiveRecord::Base
  class_inheritable_accessor :keys

  def self.initialize_keys!(*keys)
    return self.keys unless self.keys.nil?

    keys.flatten!
    keys.map!(&:to_s)

    self.keys = keys
    validates :key, :presence  => true, :inclusion => { :in => keys, :allow_blank => true }
  end

  validates :value, :presence  => true

  acts_as_list :scope => 'menu_options.key = \"#{key}\"'

  scope :options_for, lambda {|key| where(:key => key).order('menu_options.position ASC') }

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
    connection.send(:select_values, options_for(key).order(:position).project('value').to_sql, 'Menu Option Select')
  end

  def to_s
    value
  end

  # For e9 admin
  def role; 'administrator' end
end
