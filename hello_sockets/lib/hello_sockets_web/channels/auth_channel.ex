defmodule HelloSocketsWeb.AuthChannel do
  use Phoenix.Channel
  require Logger

  intercept ["push_timed"]

  import Logger

  alias HelloSockets.Pipeline.Timing

  def handle_out("push_timed", %{data: data, at: enqueued_at}, socket) do
    push(socket, "push_timed", data)

    Logger.info(
      "pipeline.push_delivered_intercepted",
      %{"enqueued_at" => enqueued_at, "latency" => Timing.unix_ms_now() - enqueued_at}
    )

    {:noreply, socket}
  end

  def join(
        "user:" <> req_user_id,
        _payload,
        socket = %{assigns: %{user_id: user_id}}
      ) do
    if req_user_id == to_string(user_id) do
      {:ok, socket}
    else
      Logger.error("#{__MODULE__} failed #{req_user_id} != #{user_id}")
      {:error, %{reason: "unauthorized"}}
    end
  end
end
