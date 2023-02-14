require 'rails_helper'

RSpec.describe 'applications show page features' do
  before(:each) do
    @applicant_1 = Application.create!(name: 'Rumiko Takahashi', address: '4307 Saddle Creek Place', city: "Orlando", state: "Florida", zip_code: 32829, status: 0, description: 'Single and has great income, flexible schedule for pet needs.')
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
        expect(page).to have_content("Name: #{@applicant_1.name}")
        expect(page).to have_content("Address: #{@applicant_1.address}")
        expect(page).to have_content(@applicant_1.city)
        expect(page).to have_content(@applicant_1.state)
        expect(page).to have_content(@applicant_1.zip_code)
        expect(page).to have_content("Status: In Progress")
        expect(page).to have_content("Description: #{@applicant_1.description}")
      end
      
      
    end

    context "the application has not yet been submitted" do 
      it "has a section on the page to 'Search for a pet to apply to your application (full or parial name)'" do 
        visit "/applications/#{@applicant_1.id}"

        expect(page).to have_content("Search for a pet to apply to your application (full or parial name)")

      end

      it "that section has an input where I can search for Pets by name" do 

        visit "/applications/#{@applicant_1.id}"
        expect(page).to have_selector("form")

      end

      it "when I fill in this field with a Pet's name and click submit, I am taken back to the application show page and under the search bar I see any pet whose name matches my search" do 
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Norma"
        click_button "Search"
        
        expect(current_path).to eq("/applications/#{@applicant_1.id}")

        expect(page).to have_content("Norma")
        expect("Pets Returned by Search").to appear_before("Norma")
      end

      it 'displays a button to adopt a pet' do
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Norma"
        click_button "Search"
        
        expect(page).to have_button("Adopt this Pet")

      end 
      it "when I click the button to adopt the pet, I am taken back to the application show page and it lists that pet" do 
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Luna"
        click_button "Search"
     
        click_button("Adopt this Pet")
        expect(current_path).to eq("/applications/#{@applicant_1.id}")
        expect(page).to have_content("Luna")
        expect(page).to have_content("Adoption Requests")
        expect(page).to_not have_content("Pets Returned by Search")


      end

      it "when I click the button to adopt the pet, I am taken back to the application show page and it lists that pet- works for multiple pets" do 
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")
        expect(current_path).to eq("/applications/#{@applicant_1.id}")
        expect(page).to have_content("Norma Jean")
        expect(page).to have_content("Adoption Requests")
        expect(page).to_not have_content("Pets Returned by Search")

        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Luna"
        click_button "Search"

        click_button("Adopt this Pet")
        expect(current_path).to eq("/applications/#{@applicant_1.id}")
        expect(page).to have_content("Norma")
        expect(page).to have_content("Luna")
        expect(page).to have_content("Adoption Requests")
        expect(page).to_not have_content("Pets Returned by Search")

      end

      it "after checking to adopt one or more pets, I see a section to submit my application" do 
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Luna"
        click_button "Search"
        expect(page).to_not have_content("Submit your application")
        click_button("Adopt this Pet")

        expect(page).to have_content("Submit your application")
        expect(page).to have_button("Submit Description")
      end

      it "after checking to adopt one or more pets, I see a section to submit my application" do 
        visit "/applications/#{@applicant_1.id}"
        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")

        fill_in "description", with: "I love cats!"
        click_button("Submit Description")

        expect(current_path).to eq("/applications/#{@applicant_1.id}")
      end

      it "after submitting the description it will show that the application is pending and will not sknow the search button nor to submit your application" do 
        visit "/applications/#{@applicant_1.id}"
        
        fill_in "search", with: "Norma Jean"
        click_button "Search"
     
        click_button("Adopt this Pet")

        fill_in "description", with: "I love cats!"
        click_button("Submit Description")

        expect(page).to have_content("Norma")
        expect(page).to_not have_button("Search")
        expect(page).to have_content("Pending")
        expect(page).to_not have_content("Submit your application")
        
      end

      it "if i visit the application show page and no pet is in the adoption cart then I will not see a section to submit the application" do 
        visit "/applications/#{@applicant_1.id}"
        
        expect(page).to_not have_content("Submit your application")
      end
      
      context "searches" do 
        it "the search parameters will return any partial matches" do 
          visit "/applications/#{@applicant_1.id}"
          
          fill_in "search", with: "Norm"
          click_button "Search"

          
          
          expect(page).to have_content(@pet1.name)
          expect(page).to have_content(@pet3.name)
          expect(page).to have_content(@pet4.name)
        end

        it "the search parameters will return any full matches" do 
          visit "/applications/#{@applicant_1.id}"
          
          fill_in "search", with: "Norma Jean"
          click_button "Search"

          
        
          expect(page).to have_content(@pet3.name)

        end
      end


    end
  end
end