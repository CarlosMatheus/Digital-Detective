class QueryController < ApplicationController


  def index

    text = get_text(params[:query])
    news_list = NewsService.get_news;
    facts_list = FactsService.get_facts;

    story = NLPService.check_content(text, news_list, facts_list);

    render json: {
      story: story
    }

  end

  private

  def get_text(query)

    if query =~ /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
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
