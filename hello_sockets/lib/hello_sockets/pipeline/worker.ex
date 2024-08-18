defmodule HelloSockets.Pipeline.Worker do
  def start_link(item) do
    Task.start_link(fn ->
      process(item)
    end)
  end

  defp process(%{item: %{data: data, user_id: user_id}, enqueued_at: unix_ms}) do
    HelloSocketsWeb.Endpoint.broadcast("user:#{user_id}", "push_timed", %{
      data: data,
      at: unix_ms
    })
  end
end
