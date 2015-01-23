module BoardsHelper
  def trello_list_options(trello_board)
    list_options = trello_board['lists'].collect { |list| [list['name'], list['id']] }
    list_options << ['Create a new list...', 'new_list']
    list_options
  end
end
