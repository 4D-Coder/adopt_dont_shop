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
  (self.application_pets.count == self.application_pets.where(approval: 1).count)
end 

def cumulative_status_denied 
  self.application_pets
  (self.application_pets.where(approval: 1).count) > 0
end 

end 