defmodule NervesBBBEEPROMTest do
  use ExUnit.Case
  # doctest NervesBBBEEPROM

  @eeprom_bbgw "test/eeprom/bbgw-eeprom.dump"
  # @eeprom_file "../brainzfw/eeprom/eeprom.bin"

  test "read BBGW EEPROM file" do
    assert {:ok, _} = NervesBBBEEPROM.read_eeprom(@eeprom_bbgw)
  end
end
