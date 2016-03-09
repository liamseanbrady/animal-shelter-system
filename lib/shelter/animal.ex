defmodule Shelter.Animal do
  defstruct id: nil,
            type: nil,
            age: nil,
            name: nil,
            description: nil,
            adopted: false

  def new(type: type, age: age, name: name, description: description) do
    %__MODULE__{
      id: :random.uniform(1_000_000_000),
      type: type, 
      age: age, 
      name: name, 
      description: description
    }
  end
end
