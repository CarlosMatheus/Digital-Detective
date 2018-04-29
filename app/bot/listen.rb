# app/bots/listen.rb

require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'

Bot.on :message do |message|
  news_list = NewsService.get_news
  facts_list = FactsService.get_facts
  story = NLPService.check_content(message.text, news_list, facts_list)

  if story.present? and story != 'to do'
    if story.is_a? Fact
      if story.fake
        text = "Eh fake! #{story.link}"
      else
        text = "Eh verdade! #{story.link}"
      end
    else
      text = "Nao tenho certeza... mas encontei essa noticia! #{story.link}"
    end
  else
    text = "Nao encontrei nada. Se eu encontrar vou te avisar!"
  end

  if message.text.downcase =~ /oi/ || message.text.downcase =~ /ola/
    text = "Olá, eu sou o Detetive Bot, o melhor do pedaço! Posso te ajudar a identificar qualquer notícia falsa, só mandar."
  end

  Bot.deliver({
    recipient: message.sender,
    message: {
      text: text
    }
  }, access_token: ENV["ACCESS_TOKEN"])
end
