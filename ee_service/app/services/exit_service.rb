class ExitService < EventService
  def call
    last_action = get_last_action

    return check_action(last_action) if last_action

    report(403, 'как вы сюда попали? охрана!')
  end

  private

  def check_action(action)
    correct_category = check_category(action.ticket_type)

    return report(403, 'неподходящая категория билета') unless correct_category

    case action.act
    when 'block'
      create_action(action, 0, false)
      report(403, 'и не возвращайтесь')
    when 'exit'
      create_action(action, 0, false)
      report(403, 'вы уже вышли')
    when 'enter'
      create_action(action, 0)
      report(200, 'до свидания')
    end
  end
end
