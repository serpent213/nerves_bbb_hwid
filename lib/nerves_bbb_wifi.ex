defmodule NervesBBBWiFi do
  @moduledoc """
  Setup functionality for the BBGW WiFi chipset.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesBbbEeprom.hello
      :world

  """

  @ti_nvs_file "/lib/firmware/ti-connectivity/wl127x-nvs.bin"

  @spec write_mac_to_nvs_file(<<_::576>>, String.t()) :: :ok | {:error, :atom}

  def write_mac_to_nvs_file(mac_bytes, filename \\ @ti_nvs_file)

  def write_mac_to_nvs_file(<<0xff, 0xff, 0xff, 0xff, 0xff, 0xff>>, filename) do
    write_mac_to_nvs_file(<<0, 0, 0, 0, 0, 0>>, filename)
  end

  def write_mac_to_nvs_file(<<b1, b2, b3, b4, b5, b6>>, filename) do
    case File.exists?(filename) do
      true ->
        block1 = <<b6, b5, b4, b3>>
        block2 = <<b2, b1>>
        {:ok, nvs} = File.open(@ti_nvs_file, [:binary, :read, :write])
        :file.position(nvs, 3)
        IO.binwrite(nvs, block1)
        :file.position(nvs, 10)
        IO.binwrite(nvs, block2)
        File.close(nvs) # returns :ok on success
      false -> {:error, :enoent}
    end
  end
end
