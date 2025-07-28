defmodule MyProjectWeb.DashboardLiveTest do
  use MyProjectWeb.ConnCase

  import Phoenix.LiveViewTest
  import MyProject.DashboardsFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  defp create_dashboard(_) do
    dashboard = dashboard_fixture()
    %{dashboard: dashboard}
  end

  describe "Index" do
    setup [:create_dashboard]

    test "lists all dashboards", %{conn: conn, dashboard: dashboard} do
      {:ok, _index_live, html} = live(conn, ~p"/dashboards")

      assert html =~ "Listing Dashboards"
      assert html =~ dashboard.description
    end

    test "saves new dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("a", "New Dashboard") |> render_click() =~
               "New Dashboard"

      assert_patch(index_live, ~p"/dashboards/new")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard created successfully"
      assert html =~ "some description"
    end

    test "updates dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(index_live, ~p"/dashboards/#{dashboard}/edit")

      assert index_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboards")

      html = render(index_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes dashboard in listing", %{conn: conn, dashboard: dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboards")

      assert index_live |> element("#dashboards-#{dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dashboards-#{dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_dashboard]

    test "displays dashboard", %{conn: conn, dashboard: dashboard} do
      {:ok, _show_live, html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert html =~ "Show Dashboard"
      assert html =~ dashboard.description
    end

    test "updates dashboard within modal", %{conn: conn, dashboard: dashboard} do
      {:ok, show_live, _html} = live(conn, ~p"/dashboards/#{dashboard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dashboard"

      assert_patch(show_live, ~p"/dashboards/#{dashboard}/show/edit")

      assert show_live
             |> form("#dashboard-form", dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#dashboard-form", dashboard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/dashboards/#{dashboard}")

      html = render(show_live)
      assert html =~ "Dashboard updated successfully"
      assert html =~ "some updated description"
    end
  end
end
