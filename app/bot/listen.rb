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
        text = "O resultado da investigação chegou. A notícia é FALSA! Tome cuidado com as fontes que você confia na internet\n Encontrei uma reportagem que desmente o boato:  #{story.link}"
      else
        text = "O resultado da investigação chegou. A notícia é VERDADEIRA! Fique tranquilo que a notícia é verdadeira\n Encontrei uma reportagem que confirma a história:  #{story.link}"
      end
    else
      text = "Infelizmente, não existem provas suficientes para eu chegar em um resultado conclusivo...\n Porém, encontrei uma pista que pode ser útil:  #{story.link}"
    end
  else
    text = "Infelizmente, não encontrei nada. Porém, o Detetive Bot nunca falha! Continuarei pesquisando e irei lhe avisar assim que chegar num resultado conclusivo."
  end

  if message.text.downcase =~ "oi" || message.text.downcase =~ "ola" || message.text.downcase =~ "olá"
    text = "Olá, eu sou o Detetive Bot, o melhor do pedaço! Posso te ajudar a identificar qualquer notícia falsa, só mandar."
  elsif message.text.downcase =~ "bom dia" || message.text.downcase =~ "boa tarde" || message.text.downcase =~ "boa noite"
    text = message.text + ", eu sou o Detetive Bot, o melhor do pedaço! Posso te ajudar a identificar qualquer notícia falsa, só mandar."
  end

  Bot.deliver({
    recipient: message.sender,
    message: {
      text: text
    }
  }, access_token: ENV["ACCESS_TOKEN"])
end
