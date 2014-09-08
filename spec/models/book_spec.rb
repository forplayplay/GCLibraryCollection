require 'spec_helper'

describe Book do
  
  let(:book) { FactoryGirl.create(:book, title: "Kittypuss: an History", isbn: "123456789" ) }

  subject { book }

  describe "accessible attributes" do
    its(:title) { should == "Kittypuss: an History" }
    its(:isbn)  { should == "123456789" }
    it { should respond_to(:language) }
    it { should respond_to(:publisher) }
    it { should respond_to(:publish_date) }
    it { should respond_to(:publication_place) }
    it { should respond_to(:authors) }
    it { should respond_to(:title) }
    it { should respond_to(:genre) }
    it { should respond_to(:pages) }
    it { should respond_to(:keywords) }
    it { should respond_to(:location) }

  end

    describe "validations" do
    it "will not create a book without a title" do  
      FactoryGirl.build(:book, title: "").should_not be_valid
    end 
  end 

end