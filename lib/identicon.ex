defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  @doc """
  Main function to generate an identicon from the given input.
  """
  def main(input) do
    input
    |> hash_input()
    |> pick_color()
    |> build_grid()
  end

  @doc """
  Hashes the input string using MD5 and converts it to a list of integers.
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end

  @doc """
  Picks an RGB color from the image's hash and updates the image struct.
  Takes the first three integers from the `hex` list of the given `%Identicon.Image{}` as
  red, green, and blue values, and returns a new image struct with the `color` field set
  to the corresponding `{r, g, b}` tuple.
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _rest]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
  Builds the grid for the identicon by chunking the hex list into rows, mirroring each row,
  flattening the list of rows, and pairing each element with its index
  """
  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid =
      hex_list
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Mirrors a row by appending the first two elements in reverse order to the end of the row.
  For example, given the row `[1, 2, 3]`, it returns `[1, 2, 3, 2, 1]`.
  Rows will always have at least 3 elements due to the chunk_every call
  """
  def mirror_row(row) do
    [first, second | _rest] = row
    row ++ [second, first]
  end
end
