defmodule VidLog.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :channel, :string
      add :title, :string
      add :link, :string
      add :published_date, :date
    end
  end
end
