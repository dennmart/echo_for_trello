module CardsHelper
  def edit_card_link(card)
    link_to "<span class='glyphicon glyphicon-pencil'></span> Edit".html_safe, card_path(card), class: "edit-card-link"
  end

  def delete_card_link(card)
    link_to "<span class='glyphicon glyphicon-remove'></span> Delete".html_safe, card_path(card), method: :delete, class: "delete-card-link"
  end

  def update_card_status_link(card)
    link_text = card.disabled? ? "Enable" : "Disable"
    link_to "<span class='glyphicon glyphicon-ban-circle'></span> #{link_text}".html_safe, update_status_card_path(card), method: :put, class: "update-card-status-link"
  end

  def board_name(boards, board_id)
    board = boards.detect { |board| board["id"] == board_id }
    board.present? ? board["name"] : "---"
  end

  def list_name(boards, board_id, list_id)
    board = boards.detect { |board| board["id"] == board_id }
    return "---" unless board.present?
    list = board["lists"].detect { |list| list["id"] == list_id }
    list.present? ? list["name"] : "---"
  end

  def card_frequency_text(card)
    if card.daily?
      "Daily"
    elsif card.weekly?
      "Every #{Date::DAYNAMES[card.frequency_period]}"
    elsif card.monthly?
      "Every month on the #{card.frequency_period.ordinalize}"
    end
  end
end
