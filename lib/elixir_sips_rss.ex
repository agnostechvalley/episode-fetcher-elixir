defmodule ElixirSipsRss do
  @episode_directory "episodes"
  @feed_url "https://elixirsips.dpdcart.com/feed"

  def download(%{numEpisodes: episodes, username: uname, password: pw}) do
    check_episode_directory
    header = auth_header(uname, pw)

    case HTTPoison.get(@feed_url, [header]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_feed(body, header, episodes)
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        IO.puts "Unauthorized - incorrect username or password"
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp check_episode_directory do
    if !File.exists?(@episode_directory) do
      File.mkdir(@episode_directory)
    end
  end

  defp auth_header(username, password) do
    encoded = Base.encode64("#{username}:#{password}")
    {"Authorization", "Basic #{encoded}"}
  end

  defp process_feed(feed, header, episodes) do
    {:ok, parsed_feed, _} = FeederEx.parse(feed)
    entries = Enum.take(parsed_feed.entries, episodes)

    Enum.map(entries, fn(entry) ->
      url = entry.enclosure.url
      Task.async(fn -> download_episode(url, header) end)
      end)
    |> Enum.map(&Task.await(&1, 2_000_000))
  end

  defp download_episode(url, header) do
    filename = "#{@episode_directory}/#{filename_from_uri(url)}"
    IO.puts "DOWNLOADING #{filename}"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url, [header])
    File.write!(filename, body)
    IO.puts "DOWNLOADED #{filename}"
  end

  defp filename_from_uri(url) do
    String.split(url, "/") |> List.last
  end
end
