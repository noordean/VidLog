defmodule VidLog.Repo do
  use Ecto.Repo,
    otp_app: :vid_log,
    adapter: Ecto.Adapters.Postgres
end
