defmodule Airports do
  @moduledoc """
  Documentation for `Airports`.
  """
  alias NimbleCSV.RFC4180, as: CSV

  def airport_csv() do
    Application.app_dir(:airports, "/priv/airports.csv")
  end

  def open_airports() do
    window = Flow.Window.trigger_every(Flow.Window.global(), 1000)
    airport_csv()
    |> File.stream!()
    |> Stream.map(fn event ->
      Process.sleep(Enum.random([0,0,0,1]))
    end)
    |> Flow.from_enumerable()
    |> Flow.partition(window: window, key: {:key, :contry})
    |> Flow.group_by(& &1.country)
    |> Flow.on_trigger(fn acc, _partition_info, {_type, _id, trigger} ->
      events =
        acc
        |> Enum.map(fn {country, data} ->
          {country, Enum.count(data)}
        end)
        |> IO.inspect(label: inspect(self()))

        case trigger do
          :done ->
            {events, acc}
          {:every, 1000} ->
            {[], acc}
        end

    end)
    |> Enum.to_list()

  end
end
