module Admin
  class ApplicationPetsController < ApplicationController
    def update
      application_pet = ApplicationPet.where(application_id: params[:id]).where(pet_id: params[:pet_id])
      require 'pry'; binding.pry
      if params[:approval] == "approved"
        application_pet.update approval: 1
        require 'pry'; binding.pry
      elsif params[:approval] == "denied"
        application_pet.update approval: 2
        require 'pry'; binding.pry
      end 

      redirect_to "/admin/applications/#{params[:id]}?"

    end
  end
end
