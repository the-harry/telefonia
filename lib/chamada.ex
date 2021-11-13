defmodule Chamada do
  @moduledoc """
  Modulo para registrar chamadas
  """

  defstruct data: nil, duracao: nil

  @doc """
  Registra chamada de um assinante

  ## params
  - assinante
  - data
  - duracao

  ##exemplo

      iex> Telefonia.start
      ...> Assinante.cadastrar("zezinho", "1234", "321", :pospago)
      ...> assinante = Assinante.buscar_assinante("1234", :pospago)
      ...> Chamada.registrar(assinante, DateTime.utc_now(), 10)
      {:ok,
      %Assinante{
        chamadas: [%Chamada{data: ~U[2021-10-31 21:50:53.953251Z], duracao: 10}],
        cpf: "321",
        nome: "zezinho",
        numero: "1234",
        plano: %Pospago{valor: 0}
      }}
  """

  def registrar(assinante, data, duracao) do
    assinante_atualizado = %Assinante{
      assinante
      | chamadas: assinante.chamadas ++ [%__MODULE__{data: data, duracao: duracao}]
    }

    Assinante.atualizar(assinante.numero, assinante_atualizado)
  end
end
