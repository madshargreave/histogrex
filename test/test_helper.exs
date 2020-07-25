defmodule FakeRegistry do
  use Histogrex, adapter: {:ets, [:set, :public, :named_table, write_concurrency: true]}

  histogrex(:user_load, min: 1, max: 10_000_000, precision: 3)
  histogrex(:high_sig, min: 459_876, max: 12_718_782, precision: 5)
  template(:http_ms, min: 2, max: 100_000, precision: 2)
end

FakeRegistry.start_link()
ExUnit.start()
