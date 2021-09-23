defmodule ProvexTest do
  use ExUnit.Case
  import Provex

  test "a → a" do
    result =
      Provex.new()
      |> pose({:->, :a, :a})
      |> elim_implication()
      |> exact()
      |> qed?()

    assert result
  end

  test "a → (b → (a ∧ b))" do
    result =
      Provex.new()
      |> pose({:->, :a, {:->, :b, {:and, :a, :b}}})
      |> elim_implication()
      |> elim_implication()
      |> elim_and()
      |> exact()
      |> exact()
      |> qed?()

    assert result
  end

  # test "a → (c → (a ∨ b))" do
  #   result =
  #     Provex.new()
  #     |> pose({:->, :a, {:->, :c, {:or, :a, :b}}})
  #     |> elim_implication()
  #     |> elim_implication()
  #     |> elim_or()
  #     |> exact()
  #     |> qed?()

  #   assert result
  # end

  # test "a → (c → (a ∧ b))" do
  #   result =
  #     Provex.new()
  #     |> pose({:->, :a, {:->, :c, {:and, :a, :b}}})
  #     |> elim_implication()
  #     |> elim_implication()
  #     |> elim_and()
  #     |> exact()
  #     |> qed?()

  #   refute result
  # end
end
