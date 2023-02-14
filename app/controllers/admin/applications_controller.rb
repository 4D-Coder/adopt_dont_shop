module Admin  
  class ApplicationsController < ApplicationController

    def show
      @applicant = Application.find(params[:id])
      # require 'pry'; binding.pry
      @show_submission = true
      if @applicant.status == "Pending"
        @show_submission = false
      end 
      require 'pry'; binding.pry
      if @applicant.cumulative_status_approved 
          @applicant.update! status:2 
          relevant_pets = Pet.joins(:application_pets).where(application_pets: {application_id: @applicant.id})
          relevant_pets.update(adoptable: false)
      elsif @applicant.cumulative_status_denied
          @applicant.update! status:3
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