require 'net/http'
require 'telegram_bot'
require_relative 'weather_get'

token = '848732811:AAGp-aa3mbiIrx0QsTz4l0XZe1OE4cia4Hg'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)
  message.reply do |reply|
    case command
      when /start/i
        reply.text = "Я привіт бот(поки)."
      when /Привіт/i
        greetings = ['бонжур', 'чао', 'привіт', 'намасте']
        reply.text = "#{greetings.sample.capitalize}, #{message.from.first_name}."
      when /Вітаю/i
        greetings = ['бонжур', 'чао', 'привіт', 'намасте']
        reply.text = "#{greetings.sample.capitalize}, #{message.from.first_name}."
      when /Погода/i
        reply.text = "Погода - #{get_weather("lviv")}."
      when /Хуй/i
        reply.text = "Ти хуй, #{message.from.first_name}. Єдиний хуй це Андрій."
      when /Бувай/i
        bye = ['бувай', 'чао', 'папа']
        reply.text = "#{bye.sample.capitalize}, #{message.from.first_name}."
      else
        reply.text = "Не розумію команду #{command.inspect}."
      end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
