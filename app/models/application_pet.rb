class ApplicationPet < ApplicationRecord
  belongs_to :pet
  belongs_to :application

  enum approval: ["No Status", "Approved", "Rejected"]

  # if we have bugs, this was previously labeled status

  def self.create_application_pet(params)
    ApplicationPet.create!(pet_id: params[:adopt], application_id: params[:id], approval: 0)
  end
end