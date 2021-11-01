defmodule Telefonia do
  @moduledoc """
  modulo principal da aplicacao
  """

  def start do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))
  end

  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  def listar_assinantes, do: Assinante.assinantes()
  def listar_assinantes_prepago, do: Assinante.assinantes_prepago()
  def listar_assinantes_pospago, do: Assinante.assinantes_pospago()

  def fazer_chamada(numero, plano, data, duracao) do
    cond do
      plano == :prepago -> Prepago.fazer_chamada(numero, data, duracao)
      plano == :pospago -> Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  def recarga(numero, data, valor), do: Recarga.nova(data, valor, numero)

  def buscar_por_numero(numero, plano \\ :all), do: Assinante.buscar_assinante(numero, plano)

  def imprimir_contas(mes, ano) do
    Assinante.assinantes_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(mes, ano, assinante.numero)

      IO.puts("Conta prepaga do assinante #{assinante}")
      IO.puts("numero #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de recargas: #{Enum.count(assinante.plano.recargas)}")
      IO.puts("==============================================================")
    end)

    Assinante.assinantes_pospago()
    |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(mes, ano, assinante.numero)

      IO.puts("Conta pospago do assinante #{assinante}")
      IO.puts("numero #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da fatura: #{assinante.plano.valor}")
      IO.puts("==============================================================")
    end)
  end
end
