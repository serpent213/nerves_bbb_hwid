defmodule NervesBBBEEPROM do
  @moduledoc """
  Documentation for NervesBbbEeprom.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesBbbEeprom.hello
      :world

  """

  # @eeprom_device "/sys/bus/i2c/devices/0-0050/eeprom"
  @eeprom_device "../eeprom.bin"

  defstruct header: nil, id: nil, version: nil, serial: nil, mac_hex: "000000000000", mac_bytes: <<0, 0, 0, 0, 0, 0>>

  @spec read_and_parse_eeprom :: {:ok, %NervesBBBEEPROM{}} | {:error, :atom}
  def read_and_parse_eeprom do
    case File.open(@eeprom_device) do
      {:ok, file} ->
        eeprom = IO.binread(file, 28)
        :file.position(file, 0x3c)
        mac_hex = IO.binread(file, 12)
        File.close(file)

        <<header::binary-size(4),
          id::binary-size(8),
          version::binary-size(4),
          serial::binary-size(12),
        >> = eeprom

        case Base.decode16(mac_hex) do
          {:ok, mac_bytes} ->
            %NervesBBBEEPROM{
              header: header,
              id: id,
              version: version,
              serial: serial,
              mac_hex: mac_hex,
              mac_bytes: mac_bytes
            }
          err -> {:error, :invalidmac}
        end
      err -> err
    end
  end
end
