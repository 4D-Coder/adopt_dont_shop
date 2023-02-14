module Admin  
  class ApplicationsController < ApplicationController

    def show
      @applicant = Application.find(params[:id])
      @show_submission = true
      if @applicant.status == "Pending"
        @show_submission = false
      end
    end
  end
end