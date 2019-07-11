defmodule VidLog.Application do
  use Application

  def start(_type, _args) do
    children = [
      worker(VidLog.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: Testtt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
