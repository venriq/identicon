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
end
