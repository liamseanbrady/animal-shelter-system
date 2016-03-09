defmodule Shelter.CacheTest do
  use ExUnit.Case

  alias Shelter.Cache

  setup do
    animal_list = %{location: "Charlottesville", animals: []}
    Cache.save(animal_list)

    {:ok, animal_list: animal_list}
  end

  test ".save adds a list to the ETS table" do
    info = :ets.info(Cache)

    assert info[:size] == 1
  end

  test ".find gets a list from the ETS table by location", %{animal_list: animal_list} do
    assert Cache.find("Charlottesville") == animal_list
  end

  test ".clear eliminates all objects from the ETS table", %{animal_list: animal_list} do
    Cache.clear

    refute Cache.find(animal_list.location)
  end
end
