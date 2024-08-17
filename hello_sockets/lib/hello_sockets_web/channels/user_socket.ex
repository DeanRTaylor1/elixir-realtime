defmodule HelloSocketsWeb.UserSocket do
  use Phoenix.Socket

  channel "ping", HelloSocketsWeb.PingChannel
  channel "wild:*", HelloSocketsWeb.WildcardChannel
  channel "dupe", HelloSocketsWeb.DedupeChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
