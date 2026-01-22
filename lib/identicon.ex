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
    |> filter_odd_squares()
    |> build_pixel_map()
    |> draw_image()
    |> save_image("images/#{input}.png")
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

  @doc """
  Filters out the grid cells with odd codes, keeping only those with even codes.

  ## Examples

      iex> image = %Identicon.Image{grid: [{0, 0}, {1, 1}, {2, 2}, {3, 3}]}
      iex> Identicon.filter_odd_squares(image)
      %Identicon.Image{grid: [{0, 0}, {2, 2}]}
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    even_cells_grid =
      Enum.filter(grid, fn {code, _index} ->
        rem(code, 2) == 0
      end)

    %Identicon.Image{image | grid: even_cells_grid}
  end

  @doc """
  Builds the pixel map for the identicon by calculating the top-left and bottom-right
  coordinates for each cell in the grid.

  ## Examples

      iex> image = %Identicon.Image{grid: [{0, 0}, {1, 1}, {2, 2}]}
      iex> Identicon.build_pixel_map(image)
      %Identicon.Image{grid: [{0, 0}, {1, 1}, {2, 2}], pixel_map: [{{0, 0}, {60, 60}}, {{60, 0}, {120, 60}}, {{120, 0}, {180, 60}}]}
  """
  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        x = rem(index, 5) * 60
        y = div(index, 5) * 60

        top_left = {x, y}
        bottom_right = {x + 60, y + 60}

        {top_left, bottom_right}
      end)

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Draws the identicon image and returns it.
  Uses the Vix library to create and manipulate the image.
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    {r, g, b} = color

    # Create a black image 
    {:ok, img} = Vix.Vips.Operation.black(300, 300, bands: 3)
    # Make it white
    {:ok, img} = Vix.Vips.Operation.linear(img, [1, 1, 1], [255, 255, 255])

    # Draw each colored rectangle
    Enum.reduce(pixel_map, img, fn {{x1, y1}, {x2, y2}}, acc_img ->
      width = x2 - x1
      height = y2 - y1
      {:ok, rect} = Vix.Vips.Operation.black(width, height, bands: 3)
      {:ok, rect} = Vix.Vips.Operation.linear(rect, [1, 1, 1], [r, g, b])
      {:ok, result} = Vix.Vips.Operation.insert(acc_img, rect, x1, y1)
      result
    end)
  end

  @doc """
  Saves the image to the specified filename.
  """
  def save_image(img, filename) do
    # Ensure the target directory exists before writing the file
    dir = Path.dirname(filename)
    :ok = File.mkdir_p(dir)

    Vix.Vips.Image.write_to_file(img, filename)
  end
end
