defmodule Pospago do
  @moduledoc """
  Modulo para clientes com bufunfa
  """

  defstruct valor: 0

  @preco_minuto 2.40

  @doc """
  registra chamada pospago

  ## params
  - numero
  - data
  - duracao

  ##exemplo

      iex> Telefonia.start
      ...> Assinante.cadastrar("zezinho", "1234", "321", :pospago)
      ...> Pospago.fazer_chamada("1234", DateTime.utc_now(), 10)

      {:ok, "Chamada de 10min efetuada."}
      isso devia quebrar o teste ne?
  """

  def fazer_chamada(numero, data, duracao) do
    Assinante.buscar_assinante(numero, :pospago)
    |> Chamada.registrar(data, duracao)

    {:ok, "Chamada de #{duracao}min efetuada."}
  end

  @doc """
  Imprime fatura pospago

  ## params
  - mes
  - ano
  - numero

  ##exemplo

      iex> Telefonia.start
      ...> Assinante.cadastrar("zezinho", "1234", "321", :pospago)
      ...> assinante = Assinante.buscar_assinante("1234", :pospago)
      ...> Chamada.registrar(assinante, DateTime.utc_now(), 10)
      ...> Pospago.imprimir_conta(DateTime.utc_now().month, DateTime.utc_now().year, "1234")

      %Assinante{
        chamadas: [
          %Chamada{data: ~U[2021-11-01 15:03:47.738740Z], duracao: 10}
        ],
        cpf: "321",
        nome: "zezinho",
        numero: "1234",
        plano: %Pospago{valor: 24.0}
      }
  """

  def imprimir_conta(mes, ano, numero) do
    assinante = Contas.imprimir(mes, ano, numero, :pospago)

    valor_total =
      assinante.chamadas
      |> Enum.map(&(&1.duracao * @preco_minuto))
      |> Enum.sum()

    %Assinante{assinante | plano: %__MODULE__{valor: valor_total}}
  end
end
