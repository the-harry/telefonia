defmodule Contas do
  @moduledoc """
  Modulo para gerenciamento de faturas
  """

  def imprimir(mes, ano, numero, plano) do
    assinante = Assinante.buscar_assinante(numero, plano)

    chamadas_do_mes = buscar_elementos_mes(assinante.chamadas, mes, ano)

    cond do
      plano == :prepago ->
        recargas_do_mes = buscar_elementos_mes(assinante.plano.recargas, mes, ano)
        plano = %Prepago{assinante.plano | recargas: recargas_do_mes}
        %Assinante{assinante | chamadas: chamadas_do_mes, plano: plano}

      plano == :pospago ->
        %Assinante{assinante | chamadas: chamadas_do_mes}
    end
  end

  defp buscar_elementos_mes(elementos, mes, ano) do
    elementos
    |> Enum.filter(&(&1.data.year == ano && &1.data.month == mes))
  end
end
