defmodule PrepagoTest do
  use ExUnit.Case
  doctest Prepago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "funcoes para ligacoes" do
    test "faz uma ligacao" do
      Assinante.cadastrar("zezinho", "12345", "321", :prepago)
      Recarga.nova(DateTime.utc_now(), 10, "12345")

      assert Prepago.fazer_chamada("12345", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou R$4.35, e voce tem apenas R$5.65"}
    end

    test "faz uma ligacao longa e nao tem creditos" do
      Assinante.cadastrar("zezinho", "12345", "321", :prepago)

      assert Prepago.fazer_chamada("12345", DateTime.utc_now(), 20) ==
               {:error, "Voce nao tem creditos!"}
    end
  end
end
