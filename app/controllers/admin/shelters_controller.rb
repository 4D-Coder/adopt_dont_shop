module Admin
  class SheltersController < ApplicationController
    
    def index
      @shelters = Shelter.reverse_alphabetize
      @shelters_with_pending_applications = Shelter.pending_applications
    end

  end
end
