defmodule NervesBBBEEPROM do
  @moduledoc """
  Functions for accessing the BBB onboard EEPROM.
  """

  # @eeprom_file "/sys/bus/i2c/devices/0-0050/eeprom"
  # @eeprom_file "test/eeprom/bbgw-eeprom.dump"
  @eeprom_file "../brainzfw/eeprom/eeprom.bin"

  @doc """
  Structure holding the EEPROM contents.
  """
  defstruct header: nil, id: nil, version: nil, serial: nil, mac_hex: "000000000000", mac_bytes: <<0, 0, 0, 0, 0, 0>>

  @doc """
  Read EEPROM from file (I2C device or file on disk for testing).

  Does not read the whole file but two chunks...

  ## Examples

      iex> NervesBbbEeprom.hello
      :world

  """
  @spec read_eeprom(String.t()) :: {:ok, binary()} | {:error, :atom}
  def read_eeprom(filename \\ @eeprom_file) do
    case File.open(filename) do
      {:ok, file} ->
        # read only the interesting parts because I2C access might be slow
        head = IO.binread(file, 28)
        :file.position(file, 0x3c)
        mac_hex = IO.binread(file, 12)
        File.close(file)
        {:ok, head <> String.duplicate(<<0>>, 32) <> mac_hex}

      err -> err
    end
  end

  @doc """
  Parse BBB onboard EEPROM contents and return struct.

  ## Examples

      iex> NervesBbbEeprom.hello
      :world

  """
  @spec parse_eeprom(binary()) :: {:ok, %NervesBBBEEPROM{}} | {:error, :atom}
  def parse_eeprom(<<raw_eeprom::binary-size(28), _::binary-size(32), mac_hex::binary-size(12), _::binary>>) do
    <<header::binary-size(4),
      id::binary-size(8),
      version::binary-size(4),
      serial::binary-size(12),
    >> = raw_eeprom

    result = %NervesBBBEEPROM{
      header: header,
      id: id,
      version: version,
      serial: serial
    }

    case Base.decode16(mac_hex) do
      {:ok, mac_bytes} ->
        %{result | mac_hex: mac_hex, mac_bytes: mac_bytes}

      _ -> result
    end
  end
end
