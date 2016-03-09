defmodule Shelter.AnimalList do
  use GenServer

  alias Shelter.Cache

  def all(animal_list) do
    GenServer.call(animal_list, :all)
  end

  def add(animal_list, animal) do
    GenServer.cast(animal_list, {:add, animal})
  end

  def update(animal_list, animal) do
    GenServer.cast(animal_list, {:update, animal})
  end

  def location(animal_list) do
    GenServer.call(animal_list, :location)
  end

  ###
  # GenServer API
  ###

  def start_link(location) do
    GenServer.start_link(__MODULE__, location)
  end

  def init(location) do
    state = Cache.find(location) || %{location: location, animals: []}
    {:ok, state}
  end

  def handle_call(:all, _from, state) do
    {:reply, state.animals, state}
  end

  def handle_call(:location, _from, state) do
    {:reply, state.location, state}
  end

  def handle_cast({:add, animal}, state) do
    state = %{state | animals: [animal | state.animals]}
    Cache.save(state)
    {:noreply, state}
  end

  def handle_cast({:update, animal}, state) do
    index = Enum.find_index state.animals, &(&1.id == animal.id)
    animals = List.replace_at(state.animals, index, animal)
    state = %{state | animals: animals}
    {:noreply, state}
  end
end
