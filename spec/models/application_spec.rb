require 'rails_helper'

RSpec.describe Application, type: :model do
  describe 'relationships' do
    it { should have_many(:application_pets) }
    it { should have_many(:pets).through(:application_pets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:city) }
    it { should define_enum_for(:status).with_values(["In Progress", "Pending", "Accepted", "Rejected"])}
  end
end