class Application < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :zip_code, :state, :city, presence: true

  has_many :application_pets
  has_many :pets, through: :application_pets

  enum status: ["In Progress", "Pending", "Approved", "Rejected"]

def cumulative_status_approved
  require 'pry'; binding.pry
  (self.application_pets.count == self.application_pets.where(approval: "Approved").count)
end 

def cumulative_status_denied 
  require 'pry'; binding.pry
  self.application_pets
  (self.application_pets.where(approval: "Rejected").count) > 0
end 

end 