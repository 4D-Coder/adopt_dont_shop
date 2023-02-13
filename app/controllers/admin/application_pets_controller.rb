module Admin
  class ApplicationPetsController < ApplicationController
    def update
      application_pet = ApplicationPet.where(application_id: params[:id]).where(pet_id: params[:pet_id])
      # require 'pry'; binding.pry
      application_pet.update approval: 1

      redirect_to "/admin/applications/#{params[:id]}?"

    end
  end
end
