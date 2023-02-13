require 'rails_helper'

RSpec.describe 'applications show page features' do
  before(:each) do
    @applicant_1 = Application.create!(name: 'Rumiko Takahashi', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')
    @applicant_2 = Application.create!(name: 'HADY MATAR', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')

    @shelter1= Shelter.create!(name: "Caring Dogs", foster_program: true, city: "Puerto escondido", rank: 1)
    @pet1 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norma", shelter_id: @shelter1.id)
    @pet2 = Pet.create!(adoptable: true, age: 23, breed: "Turkish", name: "Luna", shelter_id: @shelter1.id)
    @pet3 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norma Jean", shelter_id: @shelter1.id)
    @pet4 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norm", shelter_id: @shelter1.id)
  end

  describe 'As a visitor' do
    context 'When I visit an applications show page' do
      it 'shows the applicants attributes' do
        visit "/applications/#{@applicant_1.id}"
        # save_and_open_page
        expect(page).to have_content("Name: #{@applicant_1.name}")
        expect(page).to have_content("Address: #{@applicant_1.address}")
        expect(page).to have_content(@applicant_1.city)
        expect(page).to have_content(@applicant_1.state)
        expect(page).to have_content(@applicant_1.zip_code)
        expect(page).to have_content("Status: In_Progress")
        expect(page).to have_content("Description: #{@applicant_1.description}")
      end

      it "next to every pet, there's a button to approve the application" do
        visit "/applications/#{@applicant_1.id}"

        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")
    
        fill_in "search", with: "Luna"
        click_button "Search"
    
        click_button("Adopt this Pet")
    
        fill_in "description", with: "I love cats!"
        click_button("Submit Description")
        
        visit "/admin/applications/#{@applicant_1.id}"

        expect(page).to have_button("Approve Application for #{@pet2.name}")
        expect(page).to have_button("Approve Application for #{@pet3.name}")
      end

      it 'when I click that button to approve the application, it navigates visitor back to the application show page after clicking button' do
        visit "/applications/#{@applicant_1.id}"

        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")
    
        # fill_in "search", with: "Luna"
        # click_button "Search"
    
        # click_button("Adopt this Pet")
    
        fill_in "description", with: "I love cats!"
        click_button("Submit Description")
        
        visit "/admin/applications/#{@applicant_1.id}"
        
        click_button("Approve Application for #{@pet3.name}")

        expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")
        
      end

      it "after approving the pet, there is no button next to the pet any longer to approve or not, instead there is an indicator saying that they have been approved" do 

        visit "/applications/#{@applicant_1.id}"

        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")

        fill_in "description", with: "I love cats!"
        click_button("Submit Description")


        visit "/applications/#{@applicant_2.id}"

        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")

        fill_in "description", with: "My Kitty!"
        click_button("Submit Description")
        



        visit "/admin/applications/#{@applicant_1.id}"
        
        
        click_button("Approve Application for #{@pet3.name}")

        save_and_open_page

        expect(page).to_not have_button("Approve Application for #{@pet3.name}")

        expect(page).to have_content("Application for #{@pet3.name} is Approved.")

      end


    end
  end
end