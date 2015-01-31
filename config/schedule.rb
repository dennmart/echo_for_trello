job_type :rbenv_runner, "export PATH=\"$HOME/.rbenv/bin:$PATH\"; eval \"$(rbenv init -)\"; cd :path && bin/rails runner -e :environment ':task' :output"

every 1.day, :at => '12:01 am' do
  rbenv_runner "Card.create_pending_trello_cards"
end
