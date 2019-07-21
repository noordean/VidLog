defmodule Friends.Video do
  use Ecto.Schema

  schema "videos" do
    field :channel, :string
    field :title, :string
    field :link, :string
    field :published_date, :date
  end
end
