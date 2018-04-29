# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'open-uri'

facts_xml = Nokogiri::XML(open("http://pox.globo.com/rss/g1/e-ou-nao-e/"))

facts_xml.xpath('//item').each do |item|

  story = Story.create()

  subject = Subject.create(title: item.xpath('title').text, story_id: story.id)

  fake = (item.xpath('title').text =~ /Não é verdade!/)

  text = ActionView::Base.full_sanitizer.sanitize(item.xpath('description').text).strip.gsub(/[^\u1F600-\u1F6FF\s]/i, '')

  fact = Fact.create(link: item.xpath('guid').text, text: text,
    fake: fake, subject_id: subject.id)

  story.fact_id = fact.id
  fact.save

end


news_xml = Nokogiri::XML(open("http://pox.globo.com/rss/g1"))

news_xml.xpath('//item').each do |item|

  story = Story.create()

  subject = Subject.create(title: item.xpath('title').text, story_id: story.id)

  text = ActionView::Base.full_sanitizer.sanitize(item.xpath('description').text).strip.gsub(/[^\u1F600-\u1F6FF\s]/i, '')

  neu = New.create(link: item.xpath('guid').text, text: text, subject_id: subject.id)

  story.new_id = neu.id
  neu.save

end
