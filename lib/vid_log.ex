defmodule VidLog do
  def run do
    playlists = ~w(
      UUZ4ixYzp3PGev6UQiAgLzDA
      UUfvmvOEGw6Nqd6E9qMryE3A
      UUxX9wt5FWQUAAz4UrysqK9A
      UUIwUNuYEcZiiJqjU04yN30A
      UUp5Nix6mJCoLkH_GqcRRp1A
      UUCgNdMshuY4_RWyrGPGr9Jw
      UUiuw1W3mkBrtl6kF8_KJMYw
    )
    playlists |> Enum.each(&save_csv(fetch_video(&1)))
  end

  def columns do
    ~w(Channel Title Link PublishedDate) |> Enum.join(",")
  end

  def fetch_video(playlist) do
    {:ok, res} = HTTPoison.get(video_url(playlist))
    {:ok, body} = Poison.decode(res.body, keys: :atoms)
    %{items: [%{ snippet: video_info}]} = body

    [
      video_info.channelTitle,
      video_info.title,
      "https://www.youtube.com/watch?v=#{video_info.resourceId.videoId}",
      video_info.publishedAt
    ] |> Enum.join(",")
  end

  def save_csv(video_update) do
    published_datetime = String.split(video_update, ",") |> Enum.at(-1)

    if is_new(published_datetime) do
      filename = "vidlogs.csv"
      unless File.exists?(filename) do
        File.write!(filename, columns() <> "\n")
      end
      File.write!(filename, video_update <> "\n", [:append])
    end
  end

  def video_url(playlist_id) do
    api_key = "AIzaSyCmUHlqB1KrppgWeEGeeZ3S54OOu_jPYcY"
    "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=#{playlist_id}&maxResults=1&key=#{api_key}"
  end

  def is_new(published_datetime) do
    {:ok, datetime, _} = DateTime.from_iso8601(published_datetime)
    published_date = DateTime.to_date(datetime)
    IO.puts published_date
    today = ~D[2019-07-13] #Date.utc_today()
    Date.compare(published_date, today) == :eq
  end
end
