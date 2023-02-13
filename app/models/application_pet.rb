class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum status: [:No_Application, :Approved, :Rejected]
end