class SendContactMessageWorker
  include Sidekiq::Worker

  def perform(contact_params)
    contact_params.symbolize_keys!
    ContactMailer.send_contact_message(contact_params[:name], contact_params[:email], contact_params[:message]).deliver_now!
  end
end
