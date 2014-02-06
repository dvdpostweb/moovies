class Prospect < ActiveRecord::Base
  attr_accessible :email, :newsletters_partners, :firstname, :lastname, :locale_id, :gender, :birth_at, :zip
  before_create :set_default
  validates :email, :presence => true, :uniqueness => true
  validates :firstname, :lastname, :locale_id, :gender, :birth_at, :zip, :presence => true
  private
  def set_default
    self.newsletters_partners = 0
  end
end