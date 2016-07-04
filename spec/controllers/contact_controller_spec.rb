require 'rails_helper'

RSpec.describe ContactController, type: :controller do
  describe "#create" do
    context "invalid params" do
      it "does not enqueue the job to send the message" do
        expect(SendContactMessageWorker).to_not receive(:perform_async)
        post :create, params: { name: "John Doe", email: "johndoe@test.com", message: "" }
      end

      it "renders the :index view" do
        post :create, params: { name: "John Doe", email: "johndoe@test.com", message: "" }
        expect(response).to_not be_redirect
        expect(response).to render_template(:index)
      end
    end

    context "valid params" do
      it "enqueues a job to send the message" do
        expect(SendContactMessageWorker).to receive(:perform_async).with({ name: "John Doe", email: "johndoe@test.com", message: "This is my message!" })
        post :create, params: { name: "John Doe", email: "johndoe@test.com", message: "This is my message!" }
      end

      it "doesn't send any additional parameters to the job" do
        expect(SendContactMessageWorker).to receive(:perform_async).with({ name: "John Doe", email: "johndoe@test.com", message: "This is my message!" })
        post :create, params: { name: "John Doe", email: "johndoe@test.com", message: "This is my message!", naughty_param: "testing" }
      end

      it "redirects to the contact index page" do
        post :create, params: { name: "John Doe", email: "johndoe@test.com", message: "This is my message!" }
        expect(response).to be_redirect
        expect(response).to redirect_to(contact_index_path)
      end
    end
  end
end
