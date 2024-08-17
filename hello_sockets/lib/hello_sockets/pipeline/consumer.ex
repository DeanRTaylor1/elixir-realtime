defmodule HelloSockets.Pipeline.Consumer do
  # This module implements a GenStage consumer
  use GenStage

  # Function to start the GenStage consumer process
  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  # Initialization function
  def init(opts) do
    # Get the producer to subscribe to from the options
    # If not provided, default to HelloSockets.Pipeline.Producer
    subscribe_to =
      Keyword.get(opts, :subscribe_to, HelloSockets.Pipeline.Producer)

    # Initialize the consumer with an unused state and subscribe to the specified producer
    {:consumer, :unused, subscribe_to: subscribe_to}
  end

  # Handle events received from the producer
  def handle_events(items, _from, state) do
    # Inspect and print information about the received items
    # This includes the module name, number of items received, and the first and last items
    IO.inspect({__MODULE__, length(items), List.first(items), List.last(items)})

    # Return without changing the state
    {:noreply, [], state}
  end
end
