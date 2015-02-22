class GifsController < ApplicationController

  def index
    @query = params[:q]
    if @query.blank?
      @gifs = Gif.all
    else
      @gifs = Gif.search(@query)
    end
  end

  def show
    @gif = Gif.retrieve(params[:id])
  end

end

