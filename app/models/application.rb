class Application < ApplicationRecord
  validates :name, presence: true
  validates :status, presence: true
  validates :address, presence: true
  validates :description, presence: true
  validates :zip_code, :state, :city, presence: true

  has_many :application_pets
  has_many :pets, through: :application_pets

  enum status: ["In Progress", "Pending", "Accepted", "Rejected"]


  def fully_approved
    self.application_pets.where(approval:  "Approved").count = self.application_pets.count
  end
end 