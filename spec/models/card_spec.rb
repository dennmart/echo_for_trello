require 'rails_helper'

RSpec.describe Card, :type => :model do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:trello_board_id) }
  it { should validate_presence_of(:trello_list_id) }
  it { should validate_presence_of(:frequency) }
  it { should validate_presence_of(:frequency_period) }

  it { should validate_exclusion_of(:frequency).in_array(Card::FREQUENCY.values) }
end
