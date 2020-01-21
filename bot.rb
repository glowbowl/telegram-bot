require 'net/http'
require 'telegram_bot'
require_relative 'weather_get'

Encoding::default_external = Encoding::UTF_8

token = '848732811:AAGp-aa3mbiIrx0QsTz4l0XZe1OE4cia4Hg'

bot = TelegramBot.new(token: token)

bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)
  message.reply do |reply|
    case command
      when /start/i
        reply.text = "Я привіт бот(поки)."
      when /Привіт/i, /Вітаю/i, /Хелоу/i, /Добридень/i, /Доброго ранку/i, /Добрий ранок/i, /Вечір добрий/i, /Хей/i, /Прив/i, /Добрий день/i, /Доброго дня/i, /Добрий вечір/i, /Доброго вечора/i
        greetings = ['бонжур', 'чао', 'привіт', 'намасте']
        reply.text = "#{greetings.sample.capitalize}, #{message.from.first_name}."
      when /Погода/i, /Яка погода?/i, /Яка погода?/i, /Що по погоді?/i, /Погоді/i, /Що з погодою?/i
        reply.text = "Введіть місто у якому бажаєте подивитись погоду. (Приклад: Львів, Київ, Lviv, Kyiv)"
        puts "sending #{reply.text.inspect} to @#{message.from.username}"
        reply.send_with(bot)
        bot.get_updates() do |messageW|
          puts "@#{messageW.from.username}: #{messageW.text}"
          commandW = messageW.get_command_for(bot)
          replyW = messageW.reply
          replyW.text = get_weather(commandW)
          puts "sending #{replyW.text.inspect} to @#{message.from.username}"
          bot.send_message(replyW)
          break
        end
        break
      when /Дякую/i
        thanks = ['немає за що', 'будь ласка', 'прошу', 'нема за що', 'без проблем', 'нема за шо', 'немає за шо', 'звертайся', 'завжди будь ласка', 'будеш винен😉']
        reply.text = "#{thanks.sample.capitalize}, #{message.from.first_name}."
      when /Бувай/i, /Прощавай/i, /Був радий /i, //i, //i
        bye = ['бувай', 'чао', 'папа']
        reply.text = "#{bye.sample.capitalize}, #{message.from.first_name}."
      else
        reply.text = ("Не розумію команду " + command.inspect + ".")
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
