defmodule Prepago do
  @moduledoc """
  Modulo para clientes que nao pagam um absurdo de maneira direta
  """
  @preco_minuto 1.45

  defstruct creditos: 0, recargas: []

  @doc """
  registra chamada prepago

  ## params
  - numero
  - data
  - duracao

  ##exemplo

      iex> Telefonia.start
      ...> Assinante.cadastrar("zezinho", "1234", "321", :prepago)
      ...> Recarga.nova(DateTime.utc_now(), 10, "1234")
      ...> Prepago.fazer_chamada("1234", DateTime.utc_now(), 3)
      {:ok, "A chamada custou R$4.35, e voce tem apenas R$5.65"}
  """

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    if custo <= assinante.plano.creditos do
      plano = assinante.plano
      plano = %__MODULE__{plano | creditos: plano.creditos - custo}

      %Assinante{assinante | plano: plano}
      |> Chamada.registrar(data, duracao)

      {:ok, "A chamada custou R$#{custo}, e voce tem apenas R$#{plano.creditos}"}
    else
      {:error, "Voce nao tem creditos!"}
    end
  end

  def imprimir_conta(mes, ano, numero) do
    Contas.imprimir(mes, ano, numero, :prepago)
  end
end
