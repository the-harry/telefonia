defmodule PospagoTest do
  use ExUnit.Case
  doctest Pospago

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "it defines a struct" do
    assert %Pospago{valor: 10}.valor == 10
  end

  test "deve fazer uma ligacao" do
    Assinante.cadastrar("zezinho", "12345", "321", :pospago)

    assert Pospago.fazer_chamada("12345", DateTime.utc_now(), 3) ==
             {:ok, "Chamada de 3min efetuada."}
  end

  describe "impressao de conta pospago" do
    test "informa os valores da fatura do mes" do
      Assinante.cadastrar("zezinho", "12345", "321", :pospago)
      data = DateTime.utc_now()
      data_antiga = ~U[2021-09-25 18:51:49.214844Z]
      Pospago.fazer_chamada("12345", data, 30)
      Pospago.fazer_chamada("12345", data_antiga, 30)

      assinante = Assinante.buscar_assinante("12345", :pospago)
      assert Enum.count(assinante.chamadas) == 2

      assinante = Pospago.imprimir_conta(data.month, data.year, "12345")

      assert assinante.numero == "12345"
      assert Enum.count(assinante.chamadas) == 1

      assert assinante.plano.valor == 72.0
    end
  end
end
