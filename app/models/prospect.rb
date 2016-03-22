# == Schema Information
#
# Table name: prospects
#
#  id                   :integer          not null, primary key
#  firstname            :string(32)       default(""), not null
#  lastname             :string(32)       default(""), not null
#  email                :string(96)       default(""), not null
#  locale_id            :integer          default(0), not null
#  gender               :string(1)        default("I")
#  newsletters          :boolean          default(TRUE), not null
#  newsletters_partners :boolean          default(TRUE), not null
#  created_at           :date
#  updated_at           :date
#  birth_at             :date
#  zip                  :integer
#

class Prospect < ActiveRecord::Base
  attr_accessible :email, :newsletters_partners, :newsletters, :firstname, :lastname, :locale_id, :gender, :birth_at, :zip, :civ
  attr_reader :civ
  before_create :set_default
  validates :email, :presence => true, :uniqueness => true
  validates :locale_id, :presence => true

  def civ=(data)
    if data == 'Mme'
      self.gender = 'F'
    else
      self.gender = 'M'
    end
  end

  private
  def set_default
    self.newsletters_partners = 0
  end
end
