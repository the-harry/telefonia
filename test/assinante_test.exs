defmodule AssinanteTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("pos.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "cadastro de assinantes" do
    test "retorna estrutura de assinante" do
      assert %Assinante{nome: "teste", numero: "111", cpf: "222", plano: "plano"}.nome == "teste"
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("zezinho", "123", "321") ==
               {:ok, "Assinante zezinho cadastrado com sucesso!"}
    end

    test "retorna erro ao cadastrar existente" do
      Assinante.cadastrar("zezinho", "123", "321")

      assert Assinante.cadastrar("zezinho", "123", "321") ==
               {:error, "Assinante ja existe!"}
    end
  end

  describe "busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("zezinho", "123", "321", :pospago)

      assert Assinante.buscar_assinante("123", :pospago).nome == "zezinho"
    end

    test "busca prepago" do
      Assinante.cadastrar("zezinho", "123", "321")

      assert Assinante.buscar_assinante("123", :prepago).nome == "zezinho"
    end
  end
end
