defmodule ElixirSipsRss.CMD do
  def main([]) do
    IO.puts """

Usage: elixir_sips_rss --username username --password password

Options:

-u --username      Username
-p --password      Password
-e --numEpisodes   Number of episodes to download (default = 5)

    """
  end

  def main(args) do
    args |> parse_args |> process
  end

  defp process(%{numEpisodes: episodes, username: uname, password: pw}) do
    ElixirSipsRss.download(%{numEpisodes: episodes, username: uname, password: pw})
  end

  defp process(%{username: uname, password: pw}) do
    process(%{username: uname, password: pw, numEpisodes: 5})
  end

  defp process(_) do
    IO.puts "Please include a username and password"
  end

  defp parse_args(args) do
    {options, _, _} = OptionParser.parse(args, switches: [username: :string, password: :string, numEpisodes: :integer], aliases: [u: :username, p: :password, e: :numEpisodes])

    Enum.into(options, %{})
  end
end
