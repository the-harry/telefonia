defmodule RecargaTest do
  use ExUnit.Case
  doctest Recarga

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "it defines a struct" do
    assert %Recarga{data: DateTime.utc_now(), valor: 30}.valor == 30
  end

  test "faz uma recarga" do
    Assinante.cadastrar("zezinho", "123", "321", :prepago)

    {:ok, msg} = Recarga.nova(DateTime.utc_now(), 30, "123")

    assert(msg == "Recarga efetuada com sucesso!")

    assinante = Assinante.buscar_assinante("123", :prepago)

    plano = assinante.plano
    assert(plano.creditos == 30)

    recargas = plano.recargas
    assert Enum.count(recargas) == 1
  end
end
