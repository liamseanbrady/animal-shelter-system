defmodule Shelter.ServerTest do
  use ExUnit.Case

  alias Shelter.Server

  setup do
    on_exit fn ->
      Enum.each Server.animal_lists, fn(animal_list) ->
        Server.delete_animal_list(animal_list)
      end
    end
  end

  test ".animal_lists returns all of the child animal lists" do
    Server.add_animal_list("Charlottesville")
    Server.add_animal_list("Dundee")

    animal_lists = Server.animal_lists

    assert Enum.count(animal_lists) == 2
  end

  test ".add_animal_list adds a new supervised animal list" do
    Server.add_animal_list("Charlottesville")
    Server.add_animal_list("Dundee")

    counts = Supervisor.count_children(Server)
    
    assert counts.active == 2
  end

  test ".find_animal_list gets a list by its name" do
    Server.add_animal_list("Charlottesville")

    animal_list = Server.find_animal_list("Charlottesville")

    assert is_pid(animal_list)
  end

  test ".delete_animal_list deletes a list by its pid" do
    Server.add_animal_list("Charlottesville")
    animal_list = Server.find_animal_list("Charlottesville")

    Server.delete_animal_list(animal_list)

    counts = Supervisor.count_children(Server)

    assert counts.active == 0
  end
end
