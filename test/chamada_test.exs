defmodule ChamadaTest do
  use ExUnit.Case
  doctest Chamada

  test "it defines a struct" do
    assert %Chamada{data: DateTime.utc_now(), duracao: 10}.duracao == 10
  end
end
