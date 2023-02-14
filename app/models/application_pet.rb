class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum approval: ["No Status", "Approved", "Rejected"]
end