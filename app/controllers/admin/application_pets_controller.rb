module Admin
  class ApplicationPetsController < ApplicationController
    def update
      # require 'pry'; binding.pry
      application_pet = ApplicationPet.find_application_pet_from_ids(params)
      # require 'pry'; binding.pry

      if params[:approval] == "approved"
        application_pet.update approval: 1
      elsif params[:approval] == "denied"
        application_pet.update approval: 2
      end 
# require 'pry'; binding.pry
      redirect_to "/admin/applications/#{params[:id]}?"
    end

    def create
      created_application_pet = ApplicationPet.create_application_pet(params)
      redirect_to "/applications/#{@applicant.id}"
    end
  end
end
