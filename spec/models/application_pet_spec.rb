require 'rails_helper'

RSpec.describe ApplicationPet, type: :model do
  describe 'relationships' do
    it { should belong_to(:application) }
    it { should belong_to(:pet) }
  end

  describe 'validations' do 
    it { should define_enum_for(:approval).with_values(["No Status", "Approved", "Rejected"])}
  end

  describe "class methods" do 
    before(:each) do
      @shelter1= Shelter.create(name: "Caring Dogs", foster_program: true, city: "Puerto escondido", rank: 1)

      @pet1 = Pet.create(adoptable: true, age: 23, breed: "Domestic Shorthair", name: "Norma Jean", shelter_id: @shelter1.id)
      @pet2 = Pet.create(adoptable: true, age: 3, breed: "Domestic Shorthair", name: "Luna", shelter_id: @shelter1.id)
      @pet3 = Pet.create(adoptable: true, age: 12, breed: "Golden Retriever", name: "Moose", shelter_id: @shelter1.id)
      @pet4 = Pet.create(adoptable: true, age: 11, breed: "Bulldog", name: "Ziva", shelter_id: @shelter1.id)


      @applicant_1 = Application.create!(name: 'Rumiko Takahashi', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')

      @application_pet_1 = ApplicationPet.create!(pet_id: @pet2.id, application_id: @applicant_1.id)

    end
    describe "#self.create_application_pet(params)" do 
      it "creates a new application_pet object" do 

        expect(ApplicationPet.all.count).to eq(0)

        params = {adopt: @pet1.id, id: @applicant_1.id}

        ApplicationPet.create_application_pet(params)

        expect(ApplicationPet.all.count).to eq(1)
      end
    end

    describe "self.find_application_pet_from_ids(params)" do 
      it "can find the relevant application_pet from the pet_id and the application_id passed through as parameters" do 
        params = {id: @applicant_1.id, pet_id: @pet2.id}
        expect(ApplicationPet.find_application_pet_from_ids(params)).to eq([@application_pet_1])
      end
    end
  end
end