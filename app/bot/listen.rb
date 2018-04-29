# app/bots/listen.rb

require "facebook/messenger"

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])

# message.id          # => 'mid.1457764197618:41d102a3e1ae206a38'
# message.sender      # => { 'id' => '1008372609250235' }
# message.sent_at     # => 2016-04-22 21:30:36 +0200
# message.text        # => 'Hello, bot!'

def get_text(query)

  if query.strip =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
    require 'open-uri'

    begin
      html = Nokogiri::HTML(open(query))

      html.xpath('//p').text
    rescue
      raise ActionController::RoutingError.new('Not Found') if Rails.env.development?
      redirect_to root_url
    end
  else
    query
  end
end

Bot.on :message do |message|
  news_list = NewsService.get_news
  facts_list = FactsService.get_facts
  story = NLPService.check_content( get_text(message.text), news_list, facts_list)

  if story.present? and story != 'to do'
    link = story.link
    if story.is_a? Fact
      if story.fake
        text = "O resultado da investigação chegou. A notícia é FALSA! Tome cuidado com as fontes que você confia na internet\n Encontrei uma reportagem que desmente o boato:  #{link_to query_url(query: link)}"
      else
        text = "O resultado da investigação chegou. A notícia é VERDADEIRA! Fique tranquilo que a notícia é verdadeira\n Encontrei uma reportagem que confirma a história:  #{link_to query_url(query: link)}"
      end
    else
      text = "Infelizmente, não existem provas suficientes para eu chegar em um resultado conclusivo...\n Porém, encontrei uma pista que pode ser útil:  #{link_to query_url(query: link)}"
    end
  else
    text = "Infelizmente, não encontrei nada. Porém, o Detetive Bot nunca falha! Continuarei pesquisando e irei lhe avisar assim que chegar num resultado conclusivo."
  end

  if message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "oi" || message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "ola" || message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "olá"
    text = "Olá, eu sou o Detetive Digital, o melhor do pedaço! Posso te ajudar a identificar qualquer notícia falsa, só mandar."
  elsif message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "bom dia" || message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "boa tarde" || message.text.gsub(/[^a-zA-Z0-9\-]/,"").downcase == "boa noite"
    text = message.text + ", eu sou o Detetive Digital, o melhor do pedaço! Posso te ajudar a identificar qualquer notícia falsa, só mandar."
  end

  Bot.deliver({
    recipient: message.sender,
    message: {
      text: text
    }
  }, access_token: ENV["ACCESS_TOKEN"])
end
