defmodule NervesBBBHwId.Mixfile do
  use Mix.Project

  def project do
    [
      app: :nerves_bbb_hwid,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    [
      # name: "nerves_bbb_hwid",
      description: "BeagleBone Black (and Green Wireless) Hardware ID helpers (EEPROM, MAC address)",
      licenses: ["Apache-2.0"],
      maintainers: ["Steffen Beyer"],
      links: %{"GitHub" => "https://github.com/serpent213/nerves_bbb_hwid"}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
