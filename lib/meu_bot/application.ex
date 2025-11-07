defmodule MeuBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MeuBot.Worker.start_link(arg)
      # {MeuBot.Worker, arg}
      {MeuBot.DiscordClient, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MeuBot.Supervisor]
    Logger.info("Iniciando Discord Consumer...")
    Supervisor.start_link(children, opts)
  end
end
