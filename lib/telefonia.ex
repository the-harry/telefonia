defmodule Telefonia do
  def start do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))
  end

  def cadastrar_assinante(nome, numero, cpf, plano \\ :prepago) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end
end
