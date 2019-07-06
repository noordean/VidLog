defmodule VidLog do
  def columns do
    ~w(Channel Title Link PublishedDate) |> Enum.join(",")
  end

  def fetch_video do
    {:ok, res} = HTTPoison.get(video_url)
    {:ok, body} = Poison.decode(res.body, keys: :atoms)
    %{items: [%{ snippet: video_info}]} = body

    [
      video_info.channelTitle,
      video_info.title,
      "https://www.youtube.com/watch?v=#{video_info.resourceId.videoId}",
      video_info.publishedAt
    ]
  end

  def video_url do
    playlist_id = "UUZ4ixYzp3PGev6UQiAgLzDA"
    api_key = "AIzaSyCmUHlqB1KrppgWeEGeeZ3S54OOu_jPYcY"
    "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=#{playlist_id}&maxResults=1&key=#{api_key}"
  end
end
