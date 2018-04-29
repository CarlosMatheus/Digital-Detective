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
  story = NLPService.check_content(message.text, news_list, facts, list)

  if story.present?
	if story.fact_id.present?
		fact = Fact.find story.fact_id
		if fact.fake
			text = "Eh fake! #{fact.link}"
		else
			text = "Eh verdade! #{fact.link}"
		end
	else
		neel = New.find story.new_id
		text = "Nao tenho certeza... mas encontei essa noticia! #{neel.link}"
  else
	text = "Nao encontrei nada. Se eu encontrar vou te avisar!"
  end
		

  Bot.deliver({
    recipient: message.sender,
    message: {
      text: text
    }
  }, access_token: ENV["ACCESS_TOKEN"])
end
