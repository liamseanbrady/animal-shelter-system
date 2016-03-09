defmodule Shelter.AnimalListTest do
  use ExUnit.Case

  alias Shelter.AnimalList
  alias Shelter.Animal
  alias Shelter.Cache

  setup do
    {:ok, animal_list} = AnimalList.start_link("Charlottesville")

    on_exit fn ->
      Cache.clear
    end

    {:ok, animal_list: animal_list}
  end

  test ".all lists all of the animals in a list", %{animal_list: animal_list} do
    assert AnimalList.all(animal_list) == []
  end

  test ".add adds an animal to the animal list", %{animal_list: animal_list} do
    bubbles = Animal.new(type: "dog", age: 5, name: "Bubbles", description: "Wonderful dog")
    AnimalList.add(animal_list, bubbles)
  end

  test ".update marks as animal as having been adopted", %{animal_list: animal_list} do
    bubbles = Animal.new(type: "dog", age: 5, name: "Bubbles", description: "Wonderful dog")
    AnimalList.add(animal_list, bubbles)

    bubbles = %{bubbles | adopted: true}
    AnimalList.update(animal_list, bubbles)

    assert AnimalList.all(animal_list) == [bubbles]
  end

  test ".location returns the location of the shelter", %{animal_list: animal_list} do
    assert AnimalList.location(animal_list) == "Charlottesville"
  end
end
