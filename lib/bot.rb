require 'telegram/bot'

module Bot
  TOKEN = YAML.load(File.open("#{__dir__}/../config.yml"))[:token]
  puts "TOKEN #{TOKEN}" # 補判斷nil
  def self.start!
    Telegram::Bot::Client.run(TOKEN) do |bot|
      bot.listen do |message|
        case message.text
        when 'HI','HI!','hi','hi!'
          bot.api.send_message(chat_id: message.chat.id, text: 'Hello!')
        when 'ping'
          bot.api.send_message(chat_id: message.chat.id, text: 'pong')
        when /[~!@#$%^&*()_+\/\\]+/ # 簡單排除特殊字元
          bot.api.send_message(chat_id: message.chat.id, text: "關鍵字 [#{message.text}]: 無法判別")
        else
          ans = Parser.avmo_pw(message.text)
          if ans
            bot.api.send_message(chat_id: message.chat.id, text: "關鍵字 [#{message.text}]:")
            ans.each do |a| 
              bot.api.send_message(chat_id: message.chat.id, text: a)
            end
          else
            bot.api.send_message(chat_id: message.chat.id, text: "Hello, 無此關鍵字!")
          end
        end
      end
    end
  end
end

