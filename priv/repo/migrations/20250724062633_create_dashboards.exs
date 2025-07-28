defmodule MyProject.Repo.Migrations.CreateDashboards do
  use Ecto.Migration

  def change do
    create table(:dashboards) do
      add :title, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
