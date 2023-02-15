class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum approval: ["No Status", "Approved", "Rejected"]

  def self.create_application_pet(params)
    ApplicationPet.create(pet_id: params[:adopt], application_id: params[:id])
  end

  def self.find_application_pet_from_ids(params)
    find_by(pet_id: params[:pet_id], application_id: params[:id])
    # used to be id, now it's application id
  end
end