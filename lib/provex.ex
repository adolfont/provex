defmodule Provex do
  defstruct [:original_goal, :goals, :context, :qed, :steps]

  def new() do
    %__MODULE__{original_goal: nil, goals: [], context: [], qed: false, steps: []}
  end

  def pose(proof, proposition) do
    add_goal(proof, proposition)
  end

  def elim_implication(
        %__MODULE__{goals: [{:->, a, b} | gs], context: context, steps: steps} = proof
      ) do
    %__MODULE__{
      proof
      | goals: [b | gs],
        context: [a | context],
        steps: steps ++ [{:elim_implication, a}]
    }
  end

  def exact(%__MODULE__{goals: [g | gs], context: context, steps: steps} = proof) do
    case Enum.member?(context, g) do
      true -> %__MODULE__{proof | goals: gs, steps: steps ++ [{:exact, g}]}
    end
  end

  def elim_or_left(%__MODULE__{goals: [{:or, a, _} | gs], steps: steps} = proof) do
    %__MODULE__{
      proof
      | goals: [a | gs],
        steps: steps ++ [:elim_or_left]
    }
  end

  def elim_or_right(%__MODULE__{goals: [{:or, _, a} | gs], steps: steps} = proof) do
    %__MODULE__{
      proof
      | goals: [a | gs],
        steps: steps ++ [:elim_or_right]
    }
  end

  def elim_and(%__MODULE__{goals: [{:and, a, b} | gs], steps: steps} = proof) do
    %__MODULE__{
      proof
      | goals: [a | [b | gs]],
        steps: steps ++ [:elim_and]
    }
  end

  def qed?(%__MODULE__{goals: []} = proof) do
    %__MODULE__{proof | qed: true}
  end

  def qed?(x), do: x

  def add_goal(%__MODULE__{} = proof, goal) do
    proof
    |> Map.update(:goals, [], fn goals ->
      [goal | goals]
    end)
    |> Map.update(:original_goal, nil, fn _ ->
      goal
    end)
  end

  def program_from_proof(%__MODULE__{steps: steps}) do
    program_from_steps(steps)
  end

  def program_from_steps([]) do
    :QED
  end

  # TODO: Sintetizar um programa a partir da prova.
  #
  # Exemplo
  # a -> b -> a & b
  #
  # Ou mesmo:
  # a -> b -> {a, b}
  #
  # def proof(a, b) do
  #   {a, b}
  # end
  def program_from_steps([step | steps]) do
    case step do
      :elim_and ->
        quote do
        end

      {:elim_implication, variable} ->
        quote do
          fn unquote(variable) ->
            program_from_steps(unquote(steps))
          end
        end
    end
  end

  def ask_tactic() do
    :ok
  end

  def interactive(state) do
    tactic = ask_tactic()

    case apply(state, tactic) do
      %__MODULE__{goals: []} ->
        IO.puts("Prova concluída")

      state2 ->
        interactive(state2)
    end
  end
end
