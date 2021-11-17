require "rails_helper"

RSpec.describe "RailsAnonymizerAnonymizer" do
  context "when the DB has an email" do
    let!(:user) do
      User.create!(
        email: "private_email@example.org",
        password: "private_password",
        name: "private_name",
        address: "private_address",
        phone_number: "private_number",
      )
    end

    it "anonymizes the email" do
      RailsAnonymizer.anonymize!

      user.reload
      expect(user.email).not_to eq("private_email@example.org")
      expect(user.valid_password?("password")).to eq(true)
      expect(user.name).to eq("user_#{user.id}")
      expect(user.address).to eq("private_address")
      expect(user.phone_number).to eq("+33333333333")
    end
  end
end
