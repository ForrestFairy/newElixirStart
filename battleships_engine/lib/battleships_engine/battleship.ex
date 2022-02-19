defmodule BattleshipsEngine.Battleship do
  alias BattleshipsEngine.{Coordinate, Battleship}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  defp offsets(:square), do: [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{1, 0}, {1, 1}, {0, 1}, {0, 2}]
  defp offsets(_), do: {:error, :invalid_battleship_type}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col},
      {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate}             ->
        {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end

  def new(type, %Coordinate{} = upper_left) do
    with [_|_] = offsets <- offsets(type),
          %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
    do
      {:ok, %Battleship{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  def overlaps?(existing_battleship, new_ship), do:
    not MapSet.disjoint?(existing_battleship.coordinates, new_ship.coordinates)

  def guess(battleship, coordinate) do
    case MapSet.member?(battleship.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(battleship.coordinates, coordinate)
        {:hit, %{battleship | hit_coordinates: hit_coordinates}}
      false -> :miss
    end
  end

  def sunk?(battleship), do:
    MapSet.equal?(battleship.coordinates, battleship.hit_coordinates)
end
