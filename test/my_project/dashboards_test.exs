defmodule MyProject.DashboardsTest do
  use MyProject.DataCase

  alias MyProject.Dashboards

  describe "dashboards" do
    alias MyProject.Dashboards.Dashboard

    import MyProject.DashboardsFixtures

    @invalid_attrs %{description: nil, title: nil}

    test "list_dashboards/0 returns all dashboards" do
      dashboard = dashboard_fixture()
      assert Dashboards.list_dashboards() == [dashboard]
    end

    test "get_dashboard!/1 returns the dashboard with given id" do
      dashboard = dashboard_fixture()
      assert Dashboards.get_dashboard!(dashboard.id) == dashboard
    end

    test "create_dashboard/1 with valid data creates a dashboard" do
      valid_attrs = %{description: "some description", title: "some title"}

      assert {:ok, %Dashboard{} = dashboard} = Dashboards.create_dashboard(valid_attrs)
      assert dashboard.description == "some description"
      assert dashboard.title == "some title"
    end

    test "create_dashboard/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboards.create_dashboard(@invalid_attrs)
    end

    test "update_dashboard/2 with valid data updates the dashboard" do
      dashboard = dashboard_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title"}

      assert {:ok, %Dashboard{} = dashboard} = Dashboards.update_dashboard(dashboard, update_attrs)
      assert dashboard.description == "some updated description"
      assert dashboard.title == "some updated title"
    end

    test "update_dashboard/2 with invalid data returns error changeset" do
      dashboard = dashboard_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboards.update_dashboard(dashboard, @invalid_attrs)
      assert dashboard == Dashboards.get_dashboard!(dashboard.id)
    end

    test "delete_dashboard/1 deletes the dashboard" do
      dashboard = dashboard_fixture()
      assert {:ok, %Dashboard{}} = Dashboards.delete_dashboard(dashboard)
      assert_raise Ecto.NoResultsError, fn -> Dashboards.get_dashboard!(dashboard.id) end
    end

    test "change_dashboard/1 returns a dashboard changeset" do
      dashboard = dashboard_fixture()
      assert %Ecto.Changeset{} = Dashboards.change_dashboard(dashboard)
    end
  end
end
