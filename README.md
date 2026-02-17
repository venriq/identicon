# Identicon

This is a simple implementation of an identicon generator in Elixir.
An identicon is a visual representation of a hash value, often used as a unique avatar for users.

## Prerequisites

This project uses [ASDF](https://asdf-vm.com/) for tool version management. The required versions are defined in `.tool-versions`:

- Elixir 1.19.5 (OTP 28)
- Erlang 28.3.1

Install the required versions with:

```sh
asdf install
```

## Usage
To generate an identicon, you can use the `Identicon` module in an Elixir script or the interactive shell (IEx):

```elixir
# Generate an identicon for the string "example"
Identicon.main("example")
```

This will create the `./images/example.png` PNG image file, containing the generated identicon.

## License
This project is released into the public domain under the [Unlicense](https://unlicense.org/).

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.

## Acknowledgments
- The identicon generation algorithm is inspired by the work of [Stephen Grider](https://www.udemy.com/user/sgslo/) in the [Udemy Course](https://www.udemy.com/course/the-complete-elixir-and-phoenix-bootcamp-and-tutorial).