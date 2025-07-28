defmodule MyProject.DashboardsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MyProject.Dashboards` context.
  """

  @doc """
  Generate a dashboard.
  """
  def dashboard_fixture(attrs \\ %{}) do
    {:ok, dashboard} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> MyProject.Dashboards.create_dashboard()

    dashboard
  end
end
