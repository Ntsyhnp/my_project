defmodule MyProject.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyProjectWeb.Telemetry,
      MyProject.Repo,
      {DNSCluster, query: Application.get_env(:my_project, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyProject.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyProject.Finch},
      # Start a worker by calling: MyProject.Worker.start_link(arg)
      # {MyProject.Worker, arg},
      # Start to serve requests, typically the last entry
      MyProjectWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyProject.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyProjectWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
