require 'rails_helper'

RSpec.describe 'the Admin Shelters index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_3.pets.create(name: 'Cheetah', breed: 'sphynx', age: 8, adoptable: true)


    @applicant_1 = Application.create!(name: 'Rumiko Takahashi', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')

    @applicant_2 = Application.create!(name: 'Hady Matar', address: '19 Calle Jacarandas', city: "Puerto Escondido", state: "Oaxaca", zip_code: 98343, status: 0, description: 'Dog Lover.')
    
  end

  it 'lists all the shelter names in reverse alphabetical order' do
    visit "/admin/shelters"

    within("div#list_shelters") do 

      expect(page).to have_content(@shelter_1.name)
      expect(page).to have_content(@shelter_2.name)
      expect(page).to have_content(@shelter_3.name)
      
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
    end 
  end

  it 'shows a section for shelters withpending applications' do 

    visit "/applications/#{@applicant_1.id}"
    fill_in "search", with: "Mr. Pirate"
    click_button "Search"
 
    click_button("Adopt this Pet")

    fill_in "search", with: "Lucille Bald"
    click_button "Search"

    click_button("Adopt this Pet")

    fill_in "description", with: "I love cats!"
    click_button("Submit Description")

    visit "/applications/#{@applicant_2.id}"
    fill_in "search", with: "Lucille Bald"
    click_button "Search"
 
    click_button("Adopt this Pet")

    fill_in "description", with: "I'm also bald"
    click_button("Submit Description")

    visit "/admin/shelters"

    within("div#pending_applications") do 
      expect(page).to have_content("Shelters with Pending Applications")
      expect(page).to have_content("Pending application: #{@shelter_1.name}")
      expect(page).to have_content("Pending application: #{@shelter_3.name}")  
      expect(page).to_not have_content("Pending application: #{@shelter_2.name}")
    end
  end

  

end
