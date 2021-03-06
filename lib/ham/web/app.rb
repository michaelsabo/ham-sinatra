require 'sinatra'

module Ham
  module Web
    class App < Sinatra::Base
      configure do
        use Rack::MethodOverride
      end

      get "/" do
        @query = params[:q]
        @gifs = Gif.search(@query)
        erb :gifs
      end

      get "/tags" do
        @query = params[:q]
        @tags = Tag.search(@query)
        erb :tags
      end

      get "/tags/:tag" do
        @tag = Tag.find(params[:tag])
        @gifs = @tag.gifs
        erb :tag
      end

      delete "/:id/tags/:tag" do
        @gif = Gif.find(params[:id])
        Gif.untag(@gif.id, params[:tag])
        redirect "/#{@gif.id}"
      end

      post "/:id/tags" do
        @gif = Gif.find(params[:id])
        Gif.tag(@gif.id, params[:tag])
        redirect "/#{@gif.id}"
      end

      get "/:id" do
        @gif = Gif.find(params[:id])
        erb :gif
      end
    end
  end
end

