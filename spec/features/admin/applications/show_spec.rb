require 'rails_helper'

RSpec.describe 'applications show page features' do
  before(:each) do
    @applicant_1 = Application.create!(name: 'Rumiko Takahashi', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')
    @applicant_2 = Application.create!(name: 'HADY MATAR', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')
    @applicant_3 = Application.create!(name: 'Maria', address: '3443 Delta Rd', city: "Puerto Escondido", state: "Oaxaca", zip_code: 04343, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')

    @shelter1= Shelter.create!(name: "Caring Dogs", foster_program: true, city: "Puerto escondido", rank: 1)
    @pet1 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norma", shelter_id: @shelter1.id)
    @pet2 = Pet.create!(adoptable: true, age: 23, breed: "Turkish", name: "Luna", shelter_id: @shelter1.id)
    @pet3 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norma Jean", shelter_id: @shelter1.id)
    @pet4 = Pet.create!(adoptable: true, age: 23, breed: "Golden", name: "Norm", shelter_id: @shelter1.id)

    @application_pet1 = ApplicationPet.create!(pet_id: @pet4.id, application_id: @applicant_1.id, approval: 0)
    @application_pet2 = ApplicationPet.create!(pet_id: @pet4.id, application_id: @applicant_2.id, approval: 0)



  end

  describe 'As a visitor' do
    context 'When I visit an admin applications show page' do
      it 'shows the applicants attributes' do
        visit "/applications/#{@applicant_1.id}"
        
        expect(page).to have_content("Name: #{@applicant_1.name}")
        expect(page).to have_content("Address: #{@applicant_1.address}")
        expect(page).to have_content(@applicant_1.city)
        expect(page).to have_content(@applicant_1.state)
        expect(page).to have_content(@applicant_1.zip_code)
        expect(page).to have_content("Status: In Progress")
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


      it "next to every pet, there's a button to deny the application" do
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

        expect(page).to have_button("Deny Application for #{@pet2.name}")
        expect(page).to have_button("Deny Application for #{@pet3.name}")
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

        visit "/admin/applications/#{@applicant_1.id}"
    
        click_button("Approve Application for #{@pet4.name}")
    
        expect(page).to_not have_button("Approve Application for #{@pet4.name}")
        expect(page).to_not have_button("Deny Application for #{@pet4.name}")

        expect(page).to have_content("Application for #{@pet4.name} is Approved.")

      end

      it "after denying the pet, there is no button next to the pet any longer to approve or not, instead there is an indicator saying that they have been approved" do 

        visit "/applications/#{@applicant_1.id}"

        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")

        visit "/applications/#{@applicant_1.id}"

        fill_in "search", with: "Luna"
        click_button "Search"
     
        click_button("Adopt this Pet")

        fill_in "description", with: "My Kitty!"
        click_button("Submit Description")

        visit "/admin/applications/#{@applicant_1.id}"
        
        click_button("Deny Application for #{@pet3.name}")


        expect(page).to_not have_button("Deny Application for #{@pet3.name}")
        expect(page).to_not have_button("Approve Application for #{@pet3.name}")

        expect(page).to have_content("Application for #{@pet3.name} is Denied.")

      end

      it "Where two applicants are both applying for the same pet, Accepting or denying for one applicant does not impact the other applicant's" do 

        visit "/admin/applications/#{@applicant_1.id}"
        
        click_button("Deny Application for #{@pet4.name}")
        
        visit "/admin/applications/#{@applicant_2.id}"
        
        expect(page).to have_button("Deny Application for #{@pet4.name}")
        expect(page).to have_button("Approve Application for #{@pet4.name}")

      end

      it "when admin has accepted all of the pets for an application, taken back to admin show page and application's status has changed to approved" do 

        @application_pet3 = ApplicationPet.create!(pet_id: @pet2.id, application_id: @applicant_1.id, approval: 1)
        @application_pet3 = ApplicationPet.create!(pet_id: @pet3.id, application_id: @applicant_1.id, approval: 1)

        visit "/admin/applications/#{@applicant_1.id}"

        click_button("Approve Application for #{@pet4.name}")
        
        expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")

        expect(page).to have_content("Status of Application: Approved")

      end

      it "when admin has accepted all of the pets for an application, taken back to admin show page and application's status has changed to approved" do 

        @application_pet3 = ApplicationPet.create!(pet_id: @pet2.id, application_id: @applicant_1.id, approval: 1)
        @application_pet3 = ApplicationPet.create!(pet_id: @pet3.id, application_id: @applicant_1.id, approval: 1)
        
        visit "/admin/applications/#{@applicant_1.id}"

        click_button("Deny Application for #{@pet4.name}")
        
        expect(current_path).to eq("/admin/applications/#{@applicant_1.id}")

        expect(page).to have_content("Status of Application: Rejected")

      end

      it "after approving all pets on the application and then you visit the show page for those pets, you see the pets are no longer adoptable" do 
        @application_pet1 = ApplicationPet.create!(pet_id: @pet2.id, application_id: @applicant_3.id, approval: 0)
        @application_pet2 = ApplicationPet.create!(pet_id: @pet3.id, application_id: @applicant_3.id, approval: 1)
        visit "/pets/#{@pet2.id}"
        save_and_open_page
        expect(page).to have_content("Adoptable: true")

        visit "/admin/applications/#{@applicant_3.id}"

        click_button("Approve Application for #{@pet2.name}")

        visit "/pets/#{@pet2.id}"
        save_and_open_page

        expect(page).to have_content("Adoptable: false")

      end


    end
  end
end