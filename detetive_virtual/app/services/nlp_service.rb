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

  # def self.check_content(text, news_list, facts_list)
  def self.check_content()
  	CHECK_RESPONSE[:fake]

 #  	#binding.pry

	# # Instantiates a client
	# language = Google::Cloud::Language.new 

	# # The text to analyze
	text = "Segundo os bombeiros, as vítimas estavam indo para o trabalho. O teto de carro do carro foi aberto para retirar os ocupantes. Carro capota em avenida perto de shopping em Campo Grande Um homem de 24 e uma mulher de 30 anos saíram ilesos depois do carro onde estavam ter batido em um poste, no portão de uma empresa e capotar na avenida Ernesto Geisel, em Campo Grande, quando iam para o trabalho na manhã deste sábado (28). Segundo o Corpo de Bombeiros foi necessário usar o desencarcerador para retirar as vítimas de dentro do veículo, mas apesar disso, sofreram apenas arranhões. O motorista disse aos policiais que perdeu o controle do carro após ser fechado por outro condutor. Além do casal, o dono da oficina que teve o portão danificado também ficou assustado quando chegou para trabalhar. Na hora que eu cheguei para abrir a oficina, o carro estava tombado aqui na frente e fique assustado quando vi, disse Márcio Cardozo. Bombeiros abriram teto do carro para retirar as vítimas Evelyn Souza/TV Morena"

	# # Detects the sentiment of the text
	# #response = language.analyze_sentiment content: text, type: :PLAIN_TEXT
	# response = language.analyze_entities content: text, type: :PLAIN_TEXT, language:"pt"

	# # Get document sentiment from response
	# sentiment = response.document_sentiment

	# puts "Text: #{text}"
	# puts "Score: #{sentiment.score}, #{sentiment.magnitude}"
	letter_to_remove = [",", ".","!","'","\"",":", ";", "?","[","]","{","}","(",")","/"]
	for letter in letter_to_remove
		text = text.remove(letter)
	end
	words = text.split(" ")
	filtered_words = []
	for word in words
		filtered_words.push(word.mb_chars.downcase.to_s)
	end
	dic = {}
	for word in filtered_words
		if dic[word] == nil
			dic[word]=1
		else
			dic[word] += 1
		end
	end

	puts dic

  end

end
