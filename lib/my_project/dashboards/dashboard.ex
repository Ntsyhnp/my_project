defmodule MyProject.Dashboards.Dashboard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dashboards" do
    field :description, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(dashboard, attrs) do
    dashboard
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
