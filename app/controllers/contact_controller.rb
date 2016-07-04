class ContactController < ApplicationController
  layout "static"

  def index
  end

  def create
    if contact_params.has_key?(:name) && contact_params.has_key?(:email) && contact_params.has_key?(:message) && contact_params.to_h.all? { |k, v| !v.blank? }
      SendContactMessageWorker.perform_async(contact_params.to_h)
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
