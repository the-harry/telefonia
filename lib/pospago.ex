defmodule Pospago do
  defstruct valor: 0

  @preco_minuto 2.40

  def fazer_chamada(numero, data, duracao) do
    Assinante.buscar_assinante(numero, :pospago)
    |> Chamada.registrar(data, duracao)

    {:ok, "Chamada de #{duracao}min efetuada."}
  end

  def imprimir_conta(mes, ano, numero) do
    assinante = Contas.imprimir(mes, ano, numero, :pospago)

    valor_total =
      assinante.chamadas
      |> Enum.map(&(&1.duracao * @preco_minuto))
      |> Enum.sum()

    %Assinante{assinante | plano: %__MODULE__{valor: valor_total}}
  end
end
