defmodule Identicon do
  @moduledoc """
    Provides methods for creating a 5x5 "pixel" github-like identicon from the string
  """

  @doc """
    The main function, that takes a string as `input` parameter and pipes other needed functions.
  """
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  @doc """
    Creates an Image struct instance with an MD5 hash, saved as list from the `input` string.
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end

  @doc """
    Takes the first 3 vals from passed `image` hex and stores it as RGB value inside Image's `color` prop.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Takes the list of three elements, captures the first two values
    and appends the second and the first value to the row.
  """
  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end
end
