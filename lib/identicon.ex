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
end
