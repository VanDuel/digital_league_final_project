class EnterService < EventService
  def call
    last_action = get_last_action

    return check_action(last_action) if last_action

    ticket = get_ticket(@params[:ticket_id])

    check_ticket(ticket)
  end

  private

  def check_ticket(ticket)
    correct_ticket =
      ticket[:event_id] == @params[:event_id].to_i \
      && check_category(ticket[:category])

    return [403, {message: 'неподходящий билет'}] unless correct_ticket

    [200, {message: 'добро пожаловать'}]
  end

  def check_action(action)
    correct_category = check_category(action.ticket_type)

    return report(403, 'неподходящая категория билета') unless correct_category

    case action.act
    when 'block'
      create_action(action, 2, false)
      report(403, 'ваш билет заблокирован')
    when 'enter'
      create_action(action, 1, false)
      report(403, 'по вашему билету уже произведен вход')
    when 'exit'
      create_action(action, 1)
      report(200, 'добро пожаловать')
    end
  end
end
