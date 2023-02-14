class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum approval: ["No Status", "Approved", "Rejected"]

  def self.create_application_pet(params)
    ApplicationPet.create!(pet_id: params[:adopt], application_id: params[:id], approval: 0)
  end

  def self.find_application_pet_from_ids(params)
    where(application_id: params[:id]).where(pet_id: params[:pet_id])
  end
end