defmodule MyProjectWeb.UserDashboardLive do
  use MyProjectWeb, :live_view

  alias MyProject.Accounts
  alias MyProject.Accounts.User

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:active, "dashboard")
     |> assign(:sidebar_open, true)
     |> assign(:open_settings_submenu, false)
     |> assign(:page, 1)}
  end

  def handle_params(%{"page" => page_param}, _url, socket) do
    page = parse_page(page_param)
    {:noreply, assign_users(socket, page)}
  end

  def handle_params(_, _url, socket) do
    {:noreply, assign_users(socket, 1)}
  end

  defp parse_page(nil), do: 1
  defp parse_page(page_str) do
    case Integer.parse(page_str) do
      {page, _} when page >= 1 -> page
      _ -> 1
    end
  end

  defp assign_users(socket, page) do
    limit = 10
    offset = (page - 1) * limit
    users = Accounts.paginated_users(limit, offset)
    assign(socket, users: users, page: page)
  end

  def handle_event("toggle_sidebar", _params, socket) do
    {:noreply, update(socket, :sidebar_open, &(!&1))}
  end

  def handle_event("toggle_submenu", %{"id" => "settings"}, socket) do
    {:noreply, update(socket, :open_settings_submenu, &(!&1))}
  end

  def handle_event("nav", %{"id" => id}, socket) do
    {:noreply, assign(socket, :active, id)}
  end

  def handle_event("delete_user", %{"id" => id}, socket) do
    user = Accounts.get_user!(id)
    {:ok, _} = Accounts.delete_user(user)
    {:noreply, assign_users(socket, socket.assigns.page)}
  end

  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> redirect(to: ~p"/users/log_out")}
  end


  def render(assigns) do
    ~H"""
    <div class="flex h-screen w-full">
      <!-- Sidebar -->
      <aside class="fixed top-0 left-0 w-64 h-screen bg-pink-900 text-white shadow-lg z-40">
        <div class="p-4 border-b border-pink-700">
          <h1 class="text-2xl font-bold mb-6">User Panel</h1>
        </div>

        <a href="#" phx-click="nav" phx-value-id="dashboard"
           class={"block px-4 py-2 rounded " <> if @active == "dashboard", do: "bg-pink-900", else: "hover:bg-gray-700"}>
          Dashboard
        </a>

        <div>
          <button phx-click="toggle_submenu" phx-value-id="settings"
                  class="flex items-center justify-between w-full px-4 py-2 rounded hover:bg-gray-700">
            <span>Tetapan</span>
            <svg class="w-4 h-4 ml-2 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </button>
        </div>

        <div class={"mt-1 ml-4 space-y-1 " <> if @open_settings_submenu, do: "block", else: "hidden"}>
          <a href="#" phx-click="nav" phx-value-id="profile"
             class="block px-2 py-1 rounded hover:bg-gray-600 text-sm">Profil</a>
          <a href="#" phx-click="nav" phx-value-id="password"
             class="block px-2 py-1 rounded hover:bg-gray-600 text-sm">Tukar Password</a>
        </div>

        <!-- Bahagian bawah (Logout) -->
       <div class="mt-auto px-4 mb-4">
        <a href="#" phx-click="nav" phx-value-id="Logout"
           class={"block px-4 py-2 rounded " <> if @active == "Logout", do: "bg-pink-900", else: "hover:bg-gray-700"}>
           Logout
        </a>
       </div>
      </aside>

      <!-- Content -->
      <div class="flex-1 ml-10 p-6 bg-white-50">
        <%= if @active == "dashboard" do %>
          <div class="bg-white p-6 rounded shadow overflow-x-auto">
            <h2 class="text-xl font-bold mb-4">Senarai Email Aktif</h2>

            <table class="w-full table-auto border text-left">
              <thead class="bg-gray-100">
                <tr>
                  <th class="px-4 py-5 text-left">#</th>
                  <th class="px-4 py-5 text-left min-w-[300px]">Email</th>
                  <th class="px-4 py-5 text-left min-w-[300px]">Tarikh Daftar</th>
                  <th class="px-6 py-4 text-left min-w-[200px]">Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for {user, i} <- Enum.with_index(@users, 1) do %>
                  <tr class="hover:bg-gray-50">
                    <td class="px-6 py-4"><%= i %></td>
                    <td class="px-6 py-4"><%= user.email %></td>
                    <td class="px-6 py-4"><%= format_datetime(user.inserted_at) %></td>
                    <td class="px-6 py-4 space-x-2">
                      <a href={~p"/users/#{user.id}/edit"} class="text-blue-600 hover:underline">Edit</a>
                      <button phx-click="delete_user" phx-value-id={user.id} class="text-red-600 hover:underline">Delete</button>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>

            <!-- Pagination -->
            <div class="mt-6 flex justify-between items-center">
              <%= if @page > 1 do %>
                <.link patch={~p"/users/dashboard?page=#{@page - 1}"}>
                  <button class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300">Prev</button>
                </.link>
              <% else %>
                <span></span> <!-- Kekalkan layout kiri bila tiada Prev -->
              <% end %>

              <span class="text-sm text-gray-700">Page <%= @page %></span>

              <.link patch={~p"/users/dashboard?page=#{@page + 1}"}>
                <button class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300">Next</button>
              </.link>
            </div>
          </div>
        <% end %>

        <%= if @active == "password" do %>
          <div class="bg-white p-6 rounded shadow">Tukar kata laluan</div>
        <% end %>
      </div>
    </div>
    """
  end

  defp format_datetime(nil), do: "-"
  defp format_datetime(dt), do: Calendar.strftime(dt, "%d-%m-%Y %H:%M")
end
