class NLPService
  # Imports the Google Cloud client library
  require "google/cloud/speech"
  require "google/cloud/storage"

  CHECK_RESPONSE = {
    fake: 0,
    fact: 1,
    news: 2,
    dunno: 3
  }

  def self.get_hash(text, total_dic)
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
    if total_dic[word] == nil
      total_dic[word] = 1
    else 
      total_dic[word] += 1
    end
  end

  remove_words = ["o", "a", "um", "uma", "para"]
  for word in remove_words
    if dic[word] != nil
      dic.delete(word)
    end
  end

  return dic
  end

  def self.cossin(hash1, hash2, total_dic)
    val1 = 0
    val2 = 0
    total = 0
    total_dic.each do |key, value|
      total += value
    end

    hash1.each do |key, valeu|
      val1 += valeu
      if hash2[key] == nil
        hash2[key]=0
      end
    end
    hash2.each do |key, valeu|
      val2 += valeu
      if hash1[key] == nil
        hash1[key]=0
      end
    end
    c=0
    hash1.each do |key, valeu|
      factor = (1 - total_dic[key] / total)
      c += hash1[key] * hash2[key] * (factor**25)
    end
    # c =  Math.sqrt(c)
    if val2 > 0
      d=Math.sqrt(Math.sqrt((val1 + val2).abs/val2))
    else
      d=1
    end
    return c*d/((mod_hash(hash1)*mod_hash(hash2)))
  end

  def self.mod_hash(dic)
    a = 0
    dic.each do |key, value|
      a += value * value
    end
    return Math.sqrt(a)
  end

  def self.check_content(text, news_list, fact_check_list)
    # def self.check_content()

    # text1 = "Segundo os bombeiros, as vítimas estavam indo para o trabalho. O teto de carro do carro foi aberto para retirar os ocupantes. Carro capota em avenida perto de shopping em Campo Grande Um homem de 24 e uma mulher de 30 anos saíram ilesos depois do carro onde estavam ter batido em um poste, no portão de uma empresa e capotar na avenida Ernesto Geisel, em Campo Grande, quando iam para o trabalho na manhã deste sábado (28). Segundo o Corpo de Bombeiros foi necessário usar o desencarcerador para retirar as vítimas de dentro do veículo, mas apesar disso, sofreram apenas arranhões. O motorista disse aos policiais que perdeu o controle do carro após ser fechado por outro condutor. Além do casal, o dono da oficina que teve o portão danificado também ficou assustado quando chegou para trabalhar. Na hora que eu cheguei para abrir a oficina, o carro estava tombado aqui na frente e fique assustado quando vi, disse Márcio Cardozo. Bombeiros abriram teto do carro para retirar as vítimas Evelyn Souza/TV Morena"
    # text2 = "Participantes podem mandar fotos por aplicativo para criar banco de dados de bichos e plantas de SP. SP participa de desafio para fotografar a natureza Quem nunca fotografou um bicho curioso ou uma planta diferente enquanto andava pela cidade? Essa é justamente a proposta do \"Desafio Natureza nas Cidades\": catalogar organismos vivos nas metrópoles. O desafio acontece até as 11h59 de segunda-feira (30) em mais de 65 cidades do mundo todo, incluindo São Paulo e outras seis capitais brasileiras. Essa é a primeira edição do projeto no Brasil. O desafio funciona assim: os participantes têm do meio dia de sexta-feira (27) até as 11h59 de segunda-feira (30) para registrar imagens de qualquer organismo da natureza encontrado na cidade de São Paulo. Depois disso, eles enviam esse registro para uma plataforma por meio de um aplicativo iNaturalist ou para o site www.desafionaturezanascidades.com.br. Nessa plataforma, vários cientistas do mundo inteiro analisam o conteúdo e podem catalogar o material encontrado, possibilitando a descoberta de novas espécies e incentivando as pessoas a explorarem a natureza das selvas de pedra. A expectativa é que mais de 10 mil pessoas participem no mundo inteiro. Como participar: Encontre animais, plantas e outros organismos. Qualquer tipo de planta, árvores, orquídeas, capins entre outras, além de musgos, fungos, líquens, ou qualquer tipo de animal, como aves, mamíferos, répteis, anfíbios, peixes, moluscos, insetos, aracnídeos, vermes, protozoários basicamente qualquer forma de vida nativa de sua região. Incluindo evidências de vida selvagem (pegadas, conchas, penas, pelos e até animais mortos. Tire uma foto do que encontrou. É essencial que você registre a sua descoberta com uma fotografia e, principalmente, anote o local exato de sua observação. O modo mais fácil é utilizando o aplicativo, mas, você pode também utilizar sua câmera fotográfica e subir as imagens e dados da localização do registro no portal iNaturalist. Lembre-se a qualidade da foto não é essencial, o mais importante é o registro e a localização. Inclua suas observações na página de sua cidade. Faça o upload de suas observações em nossa plataforma (iNaturalist), durante os dias do evento (27 a 30 de Abril). Acesse a aba cidades do site (www.desafionaturezanascidades.com.br) e envie seus registros diretamente para a área exclusiva de sua cidade inscrita na competição. Você poderá enviar as suas imagens criando uma conta em nossa plataforma de compartilhamento de dados o iNaturalist ou, diretamente pelo aplicativo."
    # text4="Ocorrência foi registrada neste sábado (28), em Jaboatão dos Guararapes. Segundo CBTU, vítima dormia nos trilhos no momento do acidente. Atropelamento foi causado por um trem do tipo VLT Reprodução/TV Globo Um homem de cerca de 20 anos morreu na madrugada deste sábado (28) ao ser atropelado por um trem do tipo VLT em Jaboatão dos Guararapes, no Grande Recife. De acordo com a Companhia Brasileira de Trens Urbanos (CBTU), o acidente ocorreu por volta das 4h40, entre as estações Marcos Freire e Jorge Lins. Ainda segundo a CBTU, o homem estava dormindo nos trilhos quando o trem, que fazia a primeira viagem do dia, atropelou a vítima, que estava sem identificação no momento. Ele morreu no local. Procurada pela reportagem, a CBTU informou ter acionado o Instituto de Criminalística e o Instituto de Medicina Legal, para recolher o corpo e fazer a perícia no trecho. Apesar da ocorrência, o órgão esclarece que a circulação dos trens do tipo VLT ocorre sem intercorrências. Outro acidente Há cerca de um mês, no fim de março, um adolescente de 13 anos morreu após ser atropelado por um trem na Linha Sul do Metrô. Segundo testemunhas, o jovem tinha ido até os trilhos para pegar uma pipa e não resistiu ao impacto da colisão."
    # text5="Um homem morreu depois de ser atropelado por um trem do tipo VLT (Veículo Leve sobre Trilhos), na noite da quarta-feira (04), no Cabo de Santo Agostinho, no Grande Recife. De acordo com a Polícia Civil, a vítima era um morador de rua e não estava com identificação. Ao ser atingido, o homem teve a perna mutilada. Por volta das 21h, a Polícia foi acionada para o caso. O corpo estava bem próximo ao Terminal Integrado de Passageiros do município, no Centro do Cabo de Santo Agostinho. A polícia não soube informar de que forma o homem foi parar nos trilhos e vai investigar o caso. A Polícia disse que a vítima costumava beber pelo local e, provavelmente, estaria alcoolizada quando foi atingida.A Companhia Brasileira de Trens Urbanos (CBTU) foi procurada pela reportagem da Folha de Pernambuco mas não atendeu às ligações até o momento de publicação deste texto."
    # text6="Um homem morreu na madrugada deste sábado (28) após ser atropelado Veículo Leve sobre Trilhos (VLT) em Jaboatão dos Guararapes, no Grande Recife. De acordo com a Companhia Brasileira de Trens Urbanos (CBTU), o acidente ocorreu por volta das 4h40, entre as estações Marcos Freire e Jorge Lins. Ainda segundo a CBTU, o homem estava dormindo nos trilhos quando o trem, que fazia a primeira viagem do dia, atropelou a vítima, que estava sem identificação. Ele morreu no local. A empresa acionou a Polícia Civil para remoção do corpo. Um boletim de ocorrência foi registrado também na no Sexto Batalhão da Policia Militar em Prazeres. Um Veículo Leve sobre Trilhos (VLT), que faz a linha TIP - Cabo, descarrilou na noite desta segunda-feira (19), em Jaboatão dos Guararapes, na Região Metropolitana do Recife. De acordo com o Corpo de Bombeiros, o acidente aconteceu por volta das 18h10, na Rua Riachão, na Muribeca. Segundo a Superintendência de Trens Urbanos do Recife (CBTU), que é responsável pelo VLT, a colisão foi causada por um caminhão que tentou fazer uma ultrapassagem irregular na via. Com a manobra, os dois veículos se chocaram. Ainda segundo os bombeiros, o condutor do VLT foi retirado das ferragens pelos Bombeiros e conduzido pelo Serviço de Atendimento Móvel de Urgência (SAMU 192). O auxiliar do maquinista, um homem de 33 anos, foi conduzido pelos Bombeiros para a Unimed Ilha do Leite, na área central do Recife. Ainda segundo a CBTU, um terceiro funcionário também ficou ferido e foi encaminhado para uma unidade de saúde do Recife."
    # text7="O BANCO CENTRAL acabou de anunciar: a conta de energia elétrica terá mais um reajuste, dessa vez de 37%, e a gasolina de 14%. Vejam que absurdo! O reajuste será aplicado a partir da próxima semana. A imprensa foi comprada para não noticiar o novo reajuste abusivo. Próxima sexta haverá uma paralisação geral! CHEGA DE TANTO ROUBO!!! Se você repassar para mais 7 pessoas ou 3 grupos, conseguiremos mobilizar esse pais e esse canalha safado do temer vai cancelar esse reajuste absurdo."

    # binding.pry

    dic_text = get_hash(text)

    max = 0
    n = ""

    total_dic = {}
    for news in news_list
      dic = get_hash(news.text, total_dic)
      cos = cossin(dic_text, dic, total_dic)
      if cos > max
        max = cos
        n = news
      end
    end

    if max > 0.5
      return n
    else
      max = 0
      total_dic = {}
      fact = ""
      for fact_check in fact_check_list
        dic = get_hash(fact_check.text, total_dic)
        cos = cossin(dic_text, dic, total_dic)
        if cos > max
          max = cos
          fact = fact_check
        end
      end

      if max > 0.5
        return fact
      else
        add_to_database(text)
      end
    end

  end

  def self.add_to_database(text)
    nil
  end

  def self.audio_to_text()
    # Your Google Cloud Platform project ID
    project_id = "spatial-skein-202517"
    # binding.pry
    # Instantiates a client
    speech = Google::Cloud::Speech.new project: project_id

    # The name of the audio file to transcribe
    file_name = Rails.root.join("app", "assets", "audio_files", "WhatsApp Audio 2018-03-21 at 8.19.30 PM.ogg")

    # The audio file's encoding and sample rate
    audio = speech.audio file_name, encoding:    :OGG_OPUS  ,
                                    sample_rate: 16000,
                                    language:    "pt-BR"

    # Detects speech in the audio file
    results = audio.recognize
    # Each result represents a consecutive portion of the audio
    results.each do |result|
      puts "Transcription: #{result.transcript}"
    end


  #   # project_id   = "Your Google Cloud project ID"
  #   # storage_path = "Path to file in Cloud Storage, eg. gs://bucket/audio.raw"
  #   # storage_file_path = "audio_files/"
  #   # file = upload(local_file_path, storage_file_path)
  #   # speech = Google::Cloud::Speech.new project: project_id
  #   # audio  = speech.audio file, encoding:    :linear16, sample_rate: 16000, language:    "en-US"

  #   # operation = audio.process

  #   # puts "Operation started"

  #   # operation.wait_until_done!

  #   # results = operation.results

  #   # results.each do |result|
  #   #   puts "Transcription: #{result.transcript}"
  #   # end
  end

  # def self.upload(local_file_path, storage_file_path)
  #   project_id = "spatial-skein-202517"
  #   bucket_name       = "audio_files_bucket_bucket"
  #   # local_file_path   = "Path to local file to upload"
  #   # storage_file_path = "audio_files/"
  #   storage = Google::Cloud::Storage.new project: project_id
  #   bucket  = storage.bucket bucket_name
  #   file = bucket.create_file local_file_path, storage_file_path
  #   puts "Uploaded #{file.name}"
  #   return file
  # end

end



