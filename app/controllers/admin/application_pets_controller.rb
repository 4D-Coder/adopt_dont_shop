module Admin
  class ApplicationPetsController < ApplicationController
    def update
      application_pet = ApplicationPet.find_application_pet_from_ids(params)
      if params[:approval] == "approved"
        application_pet.update approval: 1
      elsif params[:approval] == "denied"
        application_pet.update approval: 2
      end 

      redirect_to "/admin/applications/#{params[:id]}?"
    end
  end
end
