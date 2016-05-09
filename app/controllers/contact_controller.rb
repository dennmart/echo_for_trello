class ContactController < ApplicationController
  layout "static"

  def index
  end

  def create
    contact = contact_params.to_h
    contact.reject! { |k, v| v.blank? }

    if contact.has_key?(:name) && contact.has_key?(:email) && contact.has_key?(:message)
      SendContactMessageWorker.perform_async(contact)
      redirect_to contact_index_path, notice: "Your message was successfully sent! We'll be getting back to you soon."
    else
      render :index
    end
  end

  private

  def contact_params
    params.permit(:name, :email, :message)
  end
end
