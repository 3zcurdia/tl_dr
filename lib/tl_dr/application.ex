defmodule TLDR.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: TLDR.Worker.start_link(arg)
      # {TLDR.Worker, arg}
      TLDR.OpenAI.Client.child_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TLDR.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
