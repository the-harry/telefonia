defmodule Prepago do
  @preco_minuto 1.45

  defstruct creditos: 0, recargas: []

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar_assinante(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        %Assinante{assinante | plano: plano}
        |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custou R$#{custo}, e voce tem apenas R$#{plano.creditos}"}

      true ->
        {:error, "Voce nao tem creditos!"}
    end
  end

  def imprimir_conta(mes, ano, numero) do
    Contas.imprimir(mes, ano, numero, :prepago)
  end
end
