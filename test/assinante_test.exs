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
      assert %Assinante{nome: "teste", numero: "111", cpf: "222", plano: :prepago}.nome == "teste"
    end

    test "criar uma conta prepago" do
      assert Assinante.cadastrar("zezinho", "123", "321", :prepago) ==
               {:ok, "Assinante zezinho cadastrado com sucesso!"}
    end

    test "retorna erro ao cadastrar existente" do
      Assinante.cadastrar("zezinho", "123", "321", :prepago)

      assert Assinante.cadastrar("zezinho", "123", "321", :prepago) ==
               {:error, "Assinante ja existe!"}
    end
  end

  describe "busca de assinantes" do
    test "busca pospago" do
      Assinante.cadastrar("zezinho", "123", "321", :pospago)

      assert Assinante.buscar_assinante("123", :pospago).nome == "zezinho"
      assert Assinante.buscar_assinante("123", :pospago).plano.__struct__ == Pospago
    end

    test "busca prepago" do
      Assinante.cadastrar("zezinho", "123", "321", :prepago)

      assert Assinante.buscar_assinante("123").nome == "zezinho"
      assert Assinante.buscar_assinante("123", :prepago).plano.__struct__ == Prepago
    end
  end

  describe "delete" do
    test "apaga o cliente" do
      Assinante.cadastrar("joaozinho", "321", "321", :prepago)
      Assinante.cadastrar("zezinho", "123", "321", :prepago)

      assert Assinante.deletar("123") == {:ok, "Assinante zezinho apagado!"}
    end
  end
end
