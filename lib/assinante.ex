defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastro com planos `prepago` e `pospago`

  A funcao mais usada eh a `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

  @assinantes %{:prepago => "pre.txt", :pospago => "pos.txt"}

  @doc """
  Busca para `prepago` e `pospago`, podendo passar o numero e tipo do plano

  ## params:

  - numero: telefone celular
  - key: plano do cliente, caso vazio sera considerado `:all`

  ## Exemplo:

      iex> Assinante.cadastrar("joca", "123", "123", :prepago) && Assinante.buscar_assinante("123")
      %Assinante{cpf: "123", nome: "joca", numero: "123", plano: %Prepago{creditos: 10, recargas: []}}
  """

  def buscar_assinante(numero, key \\ :all), do: buscar(numero, key)
  defp buscar(numero, :all), do: filtro(assinantes(), numero)
  defp buscar(numero, :prepago), do: filtro(assinantes_prepago(), numero)
  defp buscar(numero, :pospago), do: filtro(assinantes_pospago(), numero)
  defp filtro(lista, numero), do: Enum.find(lista, &(&1.numero == numero))

  def assinantes(), do: assinantes_prepago() ++ assinantes_pospago()
  def assinantes_prepago(), do: read(:prepago)
  def assinantes_pospago(), do: read(:pospago)

  @doc """
  Cadastro para `prepago` e `pospago`

  ## params:

  - nome: nome do cliente
  - numero: telefone celular(identificador unico)
  - cpf: doc do cliente
  - plano: opcional, caso vazio sera considerado `prepago`

  ## Exemplo:

      iex> Assinante.cadastrar("joca", "123", "123", :prepago)
      {:ok, "Assinante joca cadastrado com sucesso!"}
  """

  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar_assinante(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinante)) ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado com sucesso!"}

      _assinante ->
        {:error, "Assinante ja existe!"}
    end
  end

  def atualizar(numero, assinante) do
    {assinante_antigo, nova_lista} = deletar_item(numero)

    case assinante_antigo.plano.__struct__ == assinante.plano.__struct__ do
      true ->
        (nova_lista ++ [assinante])
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, assinante}

      false ->
        {:error, "Assinante nao pode alterar o plano."}
    end
  end

  defp pega_plano(assinante) do
    case assinante.plano.__struct__ == Prepago do
      true -> :prepago
      false -> :pospago
    end
  end

  defp write(lista_de_assinantes, plano) do
    File.write!(@assinantes[plano], lista_de_assinantes)
  end

  def deletar(numero) do
    {assinante, nova_lista} = deletar_item(numero)

    nova_lista
    |> :erlang.term_to_binary()
    |> write(assinante.plano)

    {:ok, "Assinante #{assinante.nome} apagado!"}
  end

  def deletar_item(numero) do
    assinante = buscar_assinante(numero)

    nova_lista =
      read(pega_plano(assinante))
      |> List.delete(assinante)

    {assinante, nova_lista}
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        assinantes
        |> :erlang.binary_to_term()

      {:error, :enoent} ->
        {:error, "Arquivo invalido"}
    end
  end
end
