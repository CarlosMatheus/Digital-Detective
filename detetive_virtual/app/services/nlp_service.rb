class NLPService
	#binding.pry
	#export GOOGLE_APPLICATION_CREDENTIALS="/key.json"

	#PROJECTID = "spatial-skein-202517"
	#KEYFILE   = "key.json"

	# Explicitly use service account credentials by specifying the private key
	# file.
	#storage = Google::Cloud::Storage.new project: project_id, keyfile: key_file

	# Imports the Google Cloud client library
	require "google/cloud/language"

  CHECK_RESPONSE = {
    fake: 0,
    fact: 1,
    news: 2,
    dunno: 3
  }

  #def self.check_content(text, news_list, facts_list)
  def self.check_content()
  	CHECK_RESPONSE[:fake]

  	#binding.pry

	# Instantiates a client
	language = Google::Cloud::Language.new 

	# The text to analyze
	text = "Hello, world!"

	# Detects the sentiment of the text
	#response = language.analyze_sentiment content: text, type: :PLAIN_TEXT
	response = language.analyze_entities content: text, type: :PLAIN_TEXT

	# Get document sentiment from response
	sentiment = response.document_sentiment

	puts "Text: #{text}"
	puts "Score: #{sentiment.score}, #{sentiment.magnitude}"
  end

end
