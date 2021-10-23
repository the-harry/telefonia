defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  def buscar_assinante(numero, key \\ :all) do
    buscar(numero, key)
  end

  defp buscar(numero, :all) do
    Enum.find(assinantes(), &(&1.numero == numero))
  end

  defp buscar(numero, :prepago) do
    Enum.find(assinantes_prepago(), &(&1.numero == numero))
  end

  defp buscar(numero, :pospago) do
    Enum.find(assinantes_pospago(), &(&1.numero == numero))
  end

  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)
  def assinantes(), do: assinantes_prepago() ++ assinantes_pospago()

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar_assinante(numero) do
      nil ->
        (read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}])
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante ja existe!"}
    end
  end

  defp write(lista_de_assinantes, plano) do
    File.write!(@assinantes[plano], lista_de_assinantes)
  end

  def read(plano) do
    {:ok, assinantes} = File.read(@assinantes[plano])

    assinantes
    |> :erlang.binary_to_term()
  end
end
