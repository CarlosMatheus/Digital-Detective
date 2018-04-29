class QueryController < ApplicationController


  def index

    text = get_text(params[:query])
    news_list = NewsService.get_news
    facts_list = FactsService.get_facts

    story = NLPService.check_content(text, news_list, facts_list)

    if story.present? and story != 'to do'
      if story.is_a? Fact
        if story.fake
          result_image = get_image(NLPService::CHECK_RESPONSE[:fake])
          @true_or_fake = "É Fake!"
        else
          @true_or_fake = "É Verdade!"
          result_image = get_image(NLPService::CHECK_RESPONSE[:fact])
        end
      else
        result_image = get_image(NLPService::CHECK_RESPONSE[:news])
        @true_or_fake = "Não sabemos afirmar"
      end
      @link = story.link
    else
      result_image = get_image(NLPService::CHECK_RESPONSE[:dunno])
      @true_or_fake = "Nao encontramos nada =/ Mas te avisamos quando encontrar!"
      @link = nil
    end

    render locals: {
      true_or_fake: @true_or_fake,
      link: @link,
      result_image: result_image
    }

  end

  private

  def get_image(code)
    NLPService::CHECK_RESPONSE.each do |k, v|
      if v == code
        return  k.to_s
      end
    end
  end

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

end
