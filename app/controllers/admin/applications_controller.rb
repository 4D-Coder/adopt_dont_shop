module Admin  
  class ApplicationsController < ApplicationController

    def show
      @applicant = Application.find(params[:id])
require 'pry'; binding.pry

      @relevant_1 = []
      @relevant_pet_objects_1 = []

      @applicant.pets.each do |adopted|
        @relevant_1 << @applicant.application_pets.where(pet_id: adopted.id)
        @relevant_pet_objects_1 << Pet.find(@relevant_1.flatten.first.pet_id)
        # require 'pry'; binding.pry
      end




      @show_submission = true
      if params[:search]
        @pets_show= Pet.search(params[:search])
      elsif params[:adopt] #is create function here RESTful?
        requested_to_adopt = Pet.find(params[:adopt])
        ApplicationPet.create!(pet_id: requested_to_adopt.id, application_id: @applicant.id)
        @adoptable_pets = @applicant.pets
      elsif params[:description] #Ask whether update needs to go elsewhere because of REST considerations
        @applicant.update! status:1
        @random = false 
      end 
      if @applicant.status == "Pending"
        @show_submission = false
      end
    end

    def update
      require 'pry'; binding.pry
    end

    def new

    end

    def create 
      application = Application.new(application_params)

      if application.save
        redirect_to "/applications/#{application.id}" 
      else
        redirect_to "/applications/new"
        @errors = application.errors.messages

        flash[:alert] = @errors.map do |error|
          "#{error.first.capitalize} #{error.last}.".gsub(/[\["\]]/, "")
        end.join.gsub(/\./, ". ")
      end 
    end

    private 
    def application_params 
      params.permit(:name, :address, :city, :state, :zip_code,:description )
    end
  end
end