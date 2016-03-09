defmodule Shelter.Server do
  use Supervisor

  alias Shelter.AnimalList
  alias Shelter.Cache

  def add_animal_list(location) do
    Supervisor.start_child(__MODULE__, [location])
  end

  def find_animal_list(location) do
    Enum.find animal_lists, fn(animal_list) ->
      AnimalList.location(animal_list) == location
    end
  end

  def animal_lists do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  def delete_animal_list(animal_list) do
    Supervisor.terminate_child(__MODULE__, animal_list)
  end

  ###
  # Supervisor API
  ###

  def start_link do
    server = Supervisor.start_link(__MODULE__, [], name: __MODULE__)

    animals_lists = :ets.tab2list(Cache)
    Enum.each animals_lists, fn({location, _animals}) ->
      add_animal_list(to_string(location))
    end

    server
  end

  def init(_) do
    children = [
      worker(Shelter.AnimalList, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
