defmodule BattleshipsEngine.Board do
  alias BattleshipsEngine.{Coordinate, Guesses, Battleship}

  def new(), do: %{}

  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate), do:
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate), do:
    update_in(guesses.misses, &MapSet.put(&1, coordinate))

  def position_ship(board, key, %Battleship{} = ship) do
    case overlaps_existing_battleships?(board, key, ship) do
      true  -> {:error, :overlapping_ship}
      false -> Map.put(board, key, ship)
    end
  end

  defp overlaps_existing_battleships?(board, new_key, new_ship) do
    Enum.any?(board, fn {key, ship} ->
      key != new_key and Battleship.overlaps?(ship, new_ship)
    end)
  end

  def all_ships_positioned?(board), do:
    Enum.all?(Battleship.types, &(Map.has_key?(board, &1)))

  def guess(board, %Coordinate{} = coordinate) do
    board
    |> check_all_ships(coordinate)
    |> guess_response(board)
  end

  def check_all_ships(board, coordinate) do
    Enum.find_value(board, :miss, fn {key, ship} ->
      case Battleship.guess(ship, coordinate) do
        {:hit, ship}  -> {key, ship}
        :miss         -> false
      end
    end)
  end

  defp guess_response({key, ship}, board) do
    board = %{board | key => ship}
    {:hit, sunk_check(board, key), win_check(board), board}
  end
  defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

  defp sunk_check(board, key) do
    case sunk?(board, key) do
      true  -> key
      false -> :none
    end
  end

  defp sunk?(board, key) do
    board
    |> Map.fetch!(key)
    |> Battleship.sunk?()
  end

  defp win_check(board) do
    case all_sunk?(board) do
      true  -> :win
      false -> :no_win
    end
  end

  defp all_sunk?(board), do:
    Enum.all?(board, fn {_key, ship} -> Battleship.sunk?(ship) end)
end
