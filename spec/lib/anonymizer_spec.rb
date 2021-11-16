require "rails_helper"

RSpec.describe "RailsAnonymizerAnonymizer" do
  context "when the DB has an email" do
    let!(:user) { User.create(email: "private_email", name: "private_name", phone_number: "private_number") }

    it "anonymizes the email" do
      RailsAnonymizer.anonymize!

      user.reload
      expect(user.email).not_to eq("private_email")
      expect(user.name).not_to eq("private_name")
      expect(user.phone_number).to eq("+33333333333")
    end
  end
end
