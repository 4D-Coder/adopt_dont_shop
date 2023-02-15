class ApplicationsController < ApplicationController

  def show
    @applicant = Application.find(params[:id])
    @show_submission = true
    if params[:search]
      @pets_show= Pet.search(params[:search])
    elsif params[:adopt] 
      ApplicationPet.create_application_pet(params)
    end 
  end

  def update
    @applicant = Application.find(params[:id])
    @applicant.update! status:1
    redirect_to "/applications/#{@applicant.id}"
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