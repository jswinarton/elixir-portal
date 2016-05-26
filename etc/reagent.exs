defmodule Reagent do
  def start_link(fun) do
    {:ok, spawn_link(fn -> loop(fun.()) end)}
  end

  def get(reagent, fun) do
    send reagent, {:get, self(), fun}
    receive do
      {:ok, term} -> term
      _ -> :error
    end
  end

  def update(reagent, fun) do
    send reagent, {:update, self(), fun}
    receive do
      :ok -> :ok
      _ -> :error
    end
  end

  defp loop(term) do
    receive do
      {:get, client, fun} ->
        send client, {:ok, fun.(term)}
        loop(term)
      {:update, client, fun} ->
        term = fun.(term)
        send client, :ok
        loop(term)
      _ ->
        loop(term)
    end
  end
end
