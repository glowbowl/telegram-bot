require 'telegram_bot'

token = '848732811:AAGp-aa3mbiIrx0QsTz4l0XZe1OE4cia4Hg'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /start/i
      reply.text = "Привіт бот. Спробуй команду /greet."
    when /greet/i
      greetings = ['бонжур', 'чао', 'привіт', 'намасте']
      reply.text = "#{greetings.sample.capitalize}, #{message.from.first_name}."
    else
      reply.text = "Не розумію команду #{command.inspect}."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
