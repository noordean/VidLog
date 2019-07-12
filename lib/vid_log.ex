defmodule VidLog do
  def run do
    playlists = ~w(UUZ4ixYzp3PGev6UQiAgLzDA UUfvmvOEGw6Nqd6E9qMryE3A UUxX9wt5FWQUAAz4UrysqK9A UUIwUNuYEcZiiJqjU04yN30A UUp5Nix6mJCoLkH_GqcRRp1A UUCgNdMshuY4_RWyrGPGr9Jw)
    playlists
      |> Enum.each(&save_csv(fetch_video(&1)))
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
    filename = "vidlogs.csv"
    unless File.exists?(filename) do
      File.write!(filename, columns() <> "\n")
    end
    File.write!(filename, video_update <> "\n", [:append])
  end

  def video_url(playlist_id) do
    api_key = "AIzaSyCmUHlqB1KrppgWeEGeeZ3S54OOu_jPYcY"
    "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=#{playlist_id}&maxResults=1&key=#{api_key}"
  end
end
