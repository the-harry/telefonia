defmodule Recarga do
  @moduledoc """
  modulo para gerenciar recargas
  """
  defstruct data: nil, valor: nil

  def nova(data, valor, numero) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    plano = assinante.plano

    plano = %Prepago{
      plano
      | creditos: plano.creditos + valor,
        recargas: plano.recargas ++ [%__MODULE__{data: data, valor: valor}]
    }

    assinante = %Assinante{assinante | plano: plano}
    Assinante.atualizar(numero, assinante)

    {:ok, "Recarga efetuada com sucesso!"}
  end
end
