defmodule HelloSockets.Pipeline.Producer do
  # This module implements a GenStage producer
  use GenStage

  # Function to start the GenStage process
  def start_link(opts) do
    # Split the options to extract the name
    {[name: name], _opts} = Keyword.split(opts, [:name])
    # Start the GenStage process with the given name
    GenStage.start_link(__MODULE__, :ok, name: name)
  end

  # Initialization function
  def init(_opts) do
    # Initialize the producer with an unused state and a buffer size of 10,000
    {:producer, :unused, buffer_size: 10_000}
  end

  # Handle demand from consumers
  # This implementation ignores demand, as it's using a push-based approach
  def handle_demand(_demand, state) do
    {:noreply, [], state}
  end

  # Public function to push items into the producer
  def push(item = %{}) do
    # Cast a message to the producer to notify about the new item
    GenStage.cast(__MODULE__, {:notify, item})
  end

  # Handle the push notification
  def handle_cast({:notify, item}, state) do
    # Emit the new item wrapped in a map
    {:noreply, [%{item: item}], state}
  end
end
