module Admin
  class ApplicationPetsController < ApplicationController
    def update
      application_pet = ApplicationPet.where(application_id: params[:id]).where(pet_id: params[:pet_id])
      application_pet.update approval: 1
      #=> [#<ApplicationPet:0x00007f7e0344c9c8 id: 12, pet_id: 22, application_id: 6, approval: 1>]
    end
  end
end
