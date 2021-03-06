defmodule EventBus.Postgres.Bucket do
  @moduledoc """
  Postgres event persist worker
  """

  use GenStage
  alias EventBus.Postgres.{Config, Store, EventMapper}

  def init(:ok) do
    {
      :consumer,
      :ok,
      subscribe_to: [
        {
          EventMapper,
          min_demand: Config.min_demand(), max_demand: Config.max_demand()
        }
      ]
    }
  end

  def start_link do
    GenStage.start_link(__MODULE__, :ok)
  end

  @doc false
  def handle_events(events, _from, state) do
    Store.batch_insert(events)
    {:noreply, [], state}
  end
end
