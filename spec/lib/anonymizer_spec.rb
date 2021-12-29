require "rails_helper"

RSpec.describe "RailsAnonymizerAnonymizer" do
  subject(:anonymize) { RailsAnonymizer.anonymize!(verbose: false) }

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

    before { anonymize }

    it "anonymizes the email" do
      user.reload
      expect(user.email).not_to eq("private_email@example.org")
      expect(user.valid_password?("password")).to eq(true)
      expect(user.name).to eq("user_#{user.id}")
      expect(user.address).to eq("private_address")
      expect(user.phone_number).to eq("+33333333333")
    end

    it "runs the before script" do
      expect(user.reload.before_field).to eq("lorem")
    end

    it "runs the after script" do
      expect(user.reload.after_field).to eq("ipsum")
    end
  end
end
