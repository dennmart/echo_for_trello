require 'rails_helper'

RSpec.describe BoardsHelper, :type => :helper do
  describe "#trello_list_options" do
    let(:trello_board) { { 'lists' => lists } }
    let(:lists) { [
      { 'id' => 1, 'name' => "List #1" },
      { 'id' => 2, 'name' => "List #2" },
      { 'id' => 3, 'name' => "List #3" }
    ] }

    it "creates an array of options from lists of a Trello board, including an option to create a new list" do
      options = helper.trello_list_options(trello_board)
      expect(options.size).to eq(4)
      expect(options).to include(["List #1", 1])
      expect(options).to include(["List #2", 2])
      expect(options).to include(["List #3", 3])
      expect(options).to include(["Create a new list...", "new_list"])
    end

    it "sets the option for creating a new list at the end" do
      options = helper.trello_list_options(trello_board)
      expect(options.last).to eq(["Create a new list...", "new_list"])
    end
  end
end
