class QueryController < ApplicationController


  def index

    text = get_text(params[:query])
    news_list = NewsService.get_news
    facts_list = FactsService.get_facts

    story = NLPService.check_content(text, news_list, facts_list)

    render json: {
      story: story
    }

  end

  private

  def get_text(query)

    "sfff fwefw fwfwefwe fwef w"
  end

end
