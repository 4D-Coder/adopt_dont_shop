module Admin  
  class ApplicationsController < ApplicationController

    def show
      @applicant = Application.find(params[:id])

      if @applicant.fully_approved
        redirect_to "/applications/#{@applicant.id}?status=fully_approved", method: :patch
      end

      @show_submission = true
      if @applicant.status == "Pending"
        @show_submission = false
      end
    end
  end
end