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

  describe "impressao de conta prepago" do
    test "informa os valores da conta do mes e recargas" do
      Assinante.cadastrar("zezinho", "12345", "321", :prepago)
      data = DateTime.utc_now()
      data_antiga = ~U[2021-09-25 18:51:49.214844Z]
      Recarga.nova(data, 10, "12345")
      Prepago.fazer_chamada("12345", data, 3)
      Recarga.nova(data_antiga, 10, "12345")
      Prepago.fazer_chamada("12345", data_antiga, 3)

      assinante = Assinante.buscar_assinante("12345", :prepago)
      assert Enum.count(assinante.chamadas) == 2
      assert Enum.count(assinante.plano.recargas) == 2

      assinante = Prepago.imprimir_conta(data.month, data.year, "12345")

      assert assinante.numero == "12345"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
