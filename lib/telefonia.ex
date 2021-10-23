defmodule Telefonia do
  def cadastrar_assinante(nome, numero, cpf) do
    Assinante.cadastrar(nome, numero, cpf)
  end
end
