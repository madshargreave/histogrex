defmodule Histogrex.Tests do
  use ExUnit.Case
  alias Histogrex

  # yes, sharing global state, but makes tests much faster. :deal_with_it:
  setup_all do
     for i <- (0..999_999) do
       FakeRegistry.record!(:user_load, i)
     end
     :ok
  end

  setup ctx do
    if ctx[:high_sig] do
      FakeRegistry.reset(:high_sig)
    end
    :ok
  end

  test "value at quantile" do
     for {q, v} <- [{50, 500223}, {75, 750079}, {90, 900095}, {95, 950271}, {99, 990207}, {99.9, 999423}, {99.99, 999935}] do
       assert FakeRegistry.value_at_quantile(:user_load, q) == v
     end
   end

   test "total count" do
      assert FakeRegistry.total_count(:user_load) == 1_000_000
   end

   test "max" do
     assert FakeRegistry.max(:user_load) == 1000447
	 end

   test "min" do
     assert FakeRegistry.min(:user_load) == 0
   end

   test "mean" do
     assert FakeRegistry.mean(:user_load) == 500000.013312
   end

   @tag :high_sig
   test "empty mean" do
     assert FakeRegistry.mean(:high_sig) == 0
   end

   @tag :high_sig
   test "test high significant figure" do
     for value <- [459876, 669187, 711612, 816326, 931423, 1033197, 1131895, 2477317, 3964974, 12718782] do
       FakeRegistry.record!(:high_sig, value)
     end
     assert FakeRegistry.value_at_quantile(:high_sig, 50) == 1048575
   end

   @tag :high_sig
   test "min not zero" do
     for value <- [459876, 669187, 711612] do
       FakeRegistry.record!(:high_sig, value)
     end
     # same as what the Go library gives at least
     assert FakeRegistry.min(:high_sig) == 262144
   end
end