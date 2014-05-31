module Sculptor::CLI
  class Server < Middleman::Cli::Server
    register(Middleman::Cli::Server, :server, "server", "Run Middleman preview server")
  end
end
