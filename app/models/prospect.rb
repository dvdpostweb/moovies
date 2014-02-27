class Prospect < ActiveRecord::Base
  attr_accessible :email, :newsletters_partners, :firstname, :lastname, :locale_id, :gender, :birth_at, :zip, :civ
  attr_reader :civ
  before_create :set_default
  validates :email, :presence => true, :uniqueness => true
  validates :firstname, :lastname, :locale_id, :gender, :presence => true
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