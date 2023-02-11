class ApplicationsController < ApplicationController
  def show
    @pets = session[:pets]
    @applicant = Application.find(params[:id])
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