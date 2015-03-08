require 'shakedown'
require 'redis'

REDIS_URL="redis://localhost:6379/2"

Shakedown.configure do |config|
  config.host = "http://localhost:9293"
  config.namespace = "api"

  config.start do
    %x[REDIS_URL=#{REDIS_URL} ./start 9293]
    sleep 1
  end

  config.stop do
    %x[./stop 9293]
  end

  config.before do
    redis = Redis.new(url: REDIS_URL)
    keys = redis.keys('*')
    redis.del(*keys) if keys.any?
  end
end

Shakedown.sequence do
  get "/gifs"
  get "/gifs"
  get "/gifs"

  get "/gifs" do
    status 200
    json []
  end

  get "/gifs/gif1" do
    status 404
    json({
      error: { message: "Not Found" }
    })
  end

  post "/gifs", { gif: "gif1" } do
    status 201
    json({
      id: "gif1",
      url: "http://i.imgur.com/gif1.gif",
      thumbnail_url: "http://i.imgur.com/gif1b.gif"
    })
  end

  get "/gifs" do
    status 200
    json [{
      id: "gif1",
      url: "http://i.imgur.com/gif1.gif",
      thumbnail_url: "http://i.imgur.com/gif1b.gif"
    }]
  end

  get "/gifs/gif1" do
    status 200
    json({
      id: "gif1",
      url: "http://i.imgur.com/gif1.gif",
      thumbnail_url: "http://i.imgur.com/gif1b.gif"
    })
  end

  post "/gifs", { gif: "gif2" } do
    status 201
    json({
      id: "gif2",
      url: "http://i.imgur.com/gif2.gif",
      thumbnail_url: "http://i.imgur.com/gif2b.gif"
    })
  end

  get "/gifs" do
    status 200
    json [{
      id: "gif2",
      url: "http://i.imgur.com/gif2.gif",
      thumbnail_url: "http://i.imgur.com/gif2b.gif"
    }, {
      id: "gif1",
      url: "http://i.imgur.com/gif1.gif",
      thumbnail_url: "http://i.imgur.com/gif1b.gif"
    }]
  end

  get "/gifs/gif2" do
    status 200
    json({
      id: "gif2",
      url: "http://i.imgur.com/gif2.gif",
      thumbnail_url: "http://i.imgur.com/gif2b.gif"
    })
  end

  get "/tags" do
    status 200
    json []
  end

  post "/gifs/gif1/tags", { tag: "Shared Tag" } do
    status 201
    json({
      id: "shared-tag",
      text: "shared tag"
    })
  end

  post "/gifs/gif1/tags", { tag: "Custom Tag 1" } do
    status 201
    json({
      id: "custom-tag-1",
      text: "custom tag 1"
    })
  end

  post "/gifs/gif2/tags", { tag: "Shared Tag" } do
    status 201
    json({
      id: "shared-tag",
      text: "shared tag"
    })
  end

  post "/gifs/gif2/tags", { tag: "Custom Tag 2" } do
    status 201
    json({
      id: "custom-tag-2",
      text: "custom tag 2"
    })
  end

  get "/tags" do
    status 200
    json [{
      id: "custom-tag-2",
      text: "custom tag 2"
    }, {
      id: "custom-tag-1",
      text: "custom tag 1"
    }, {
      id: "shared-tag",
      text: "shared tag"
    }]
  end

  get "/gifs/gif1/tags" do
    status 200
    json [{
      id: "custom-tag-1",
      text: "custom tag 1"
    }, {
      id: "shared-tag",
      text: "shared tag"
    }]
  end

  get "/gifs/gif2/tags" do
    status 200
    json [{
      id: "custom-tag-2",
      text: "custom tag 2"
    }, {
      id: "shared-tag",
      text: "shared tag"
    }]
  end

  get "/tags?q=shared" do
    status 200
    json [{
      id: "shared-tag",
      text: "shared tag"
    }]
  end

  get "/tags/complete?q=cust" do
    status 200
    json [{
      id: "custom-tag-2",
      text: "custom tag 2"
    }, {
      id: "custom-tag-1",
      text: "custom tag 1"
    }]
  end

  delete "/gifs/gif1/tags/custom-tag-1" do
    status 202
    json({
      id: "custom-tag-1",
      text: "custom tag 1"
    })
  end

  get "/gifs/gif1/tags" do
    status 200
    json [{
      id: "shared-tag",
      text: "shared tag"
    }]
  end

  get "/gifs?q=shared" do
    status 200
    json [{
      id: "gif1",
      url: "http://i.imgur.com/gif1.gif",
      thumbnail_url: "http://i.imgur.com/gif1b.gif"
    }, {
      id: "gif2",
      url: "http://i.imgur.com/gif2.gif",
      thumbnail_url: "http://i.imgur.com/gif2b.gif"
    }]
  end

  get "/gifs?q=custom" do
    status 200
    json [{
      id: "gif2",
      url: "http://i.imgur.com/gif2.gif",
      thumbnail_url: "http://i.imgur.com/gif2b.gif"
    }]
  end
end

