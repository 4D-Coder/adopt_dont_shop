require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
    it { should have_many(:application_pets) }
    it { should have_many(:applications).through(:application_pets) }

  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @pet_4 = @shelter_1.pets.create(name: 'Norm', breed: 'Golden', age: 23, adoptable: true)
    @pet_5 = @shelter_1.pets.create(name: 'Norma', breed: 'Golden', age: 23, adoptable: true)
    @pet_6 = @shelter_1.pets.create(name: 'Norma Jean', breed: 'Golden', age: 23, adoptable: true)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end

    describe '.search(input)' do 
      it 'returns the matching pet based on the name' do 

        input = "Mr. Pirate"
        
        expect(Pet.search(input)).to eq([@pet_1])
      end

      it 'returns matches based on partial search param' do
        input = "Norm"

        expect(Pet.search(input)).to eq([@pet_4, @pet_5, @pet_6])
      end

      it 'returns matches based on case insensitive and/or partial search param' do

        input = "NOrM"

        expect(Pet.search(input)).to eq([@pet_4, @pet_5, @pet_6])
      end
    end
  end
end
