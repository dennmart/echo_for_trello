class SendContactMessageWorker
  include Sidekiq::Worker

  def perform(contact_params)
    ContactMailer.send_contact_message(contact_params[:name], contact_params[:email], contact_params[:message]).deliver_now!
  end
end
