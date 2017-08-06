defmodule NervesBBBWiFi do
  @moduledoc """
  Documentation for NervesBBBWiFi.
  """

  @doc """
  Hello world.

  ## Examples

      iex> NervesBbbEeprom.hello
      :world

  """

  # @ti_nvs_file "/lib/firmware/ti-connectivity/wl127x-nvs.bin"
  @ti_nvs_file "../wl127x-nvs.bin"

  @spec write_mac_to_nvs_file(<<_::6>>) :: :ok | {:error, :atom}
  def write_mac_to_nvs_file(<<0xff, 0xff, 0xff, 0xff, 0xff, 0xff>>), do: write_mac_to_nvs_file(<<0, 0, 0, 0, 0, 0>>)
  def write_mac_to_nvs_file(<<b1, b2, b3, b4, b5, b6>>) do
    case File.exists?(@ti_nvs_file) do
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
