defmodule MyProjectWeb.UserDashboardLive do
  use MyProjectWeb, :live_view

  alias MyProject.Accounts
  alias MyProject.Accounts.User

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:active, "dashboard")
     |> assign(:sidebar_open, &(!&1))
     |> assign(:"home", sidebar_open: true)
     |> assign(:open_settings_submenu, false)
     |> assign(:filters, %{"status" => "all", "search" => ""})
     |> assign(:users, Accounts.list_users())
     |> assign(:query,  "")
     |> assign(:role,  "all")
     |> assign(:filters, %{"role" => "all"})
     |> assign(:users, [])
     |> assign(:page, 1)}
  end

  def handle_params(params, _uri, socket) do
    filters = %{
      "role" => Map.get(params, "role", "all")
    }

    page = Map.get(params, "page", "1") |> String.to_integer()

    {users, has_next_page} = Accounts.list_users_with_filters(filters, page)

    {:noreply,
     assign(socket,
       filters: filters,
       users: users,
       page: page,
       has_next_page: has_next_page
     )}
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
    users = Accounts.paginated_users(limit + 1, offset)

    {displayed_users, has_next_page} =
      if length(users) > limit do
        {Enum.take(users, limit), true}
      else
        {users, false}
      end

    assign(socket,
      users: displayed_users,
      page: page,
      has_next_page: has_next_page
    )
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

  def handle_event("search", %{"query" => query}, socket) do
    users = Accounts.list_users(%{query: query, role: socket.assigns.role || "all"})
    {:noreply, assign(socket, users: users, query: query)}
  end


  def handle_event("logout", _params, socket) do
    {:noreply,
     socket
     |> redirect(to: ~p"/users/log_out")}
  end

  def handle_event("filter", %{"filters" => filters}, socket) do
    query = [role: filters["role"], page: 1]
    {:noreply, push_patch(socket, to: ~p"/users/dashboard?#{query}")}
  end




  def render(assigns) do
    ~H"""
    <div class="flex h-screen w-full">
    <!-- Burger Menu Button -->
    <button
     phx-click="toggle_sidebar"
     class="fixed top-4 left-4 z-50 p-2 rounded-md bg-pink-900 text-white md:hidden"
      >
      <!-- Heroicon: Menu -->
       <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none"
       viewBox="0 0 24 24" stroke="currentColor">
    <path stroke-linecap="round" stroke-linejoin="round"
          stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
     </svg>
    </button>


      <!-- Sidebar -->
        <aside class={
        "fixed top-0 left-0 w-64 h-screen bg-pink-900 text-white shadow-lg z-40 transform transition-transform duration-300 " <>
        if @sidebar_open, do: "translate-x-0", else: "-translate-x-full"
       }>

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
      <div class="flex-1 ml-1 p-6 bg-white-50">
        <%= if @active == "dashboard" do %>
          <div class="bg-white p-6 rounded shadow overflow-x-auto">

            <!-- Wrapper untuk search + filter supaya selari -->
                <div class="flex flex-wrap gap-4 justify-between items-center mb-6">

                  <!-- Search Form -->
                  <form phx-change="search">
                    <input type="text" name="query" value={@query} placeholder="Cari email..."
                      class="border border-pink-300 bg-pink-50 text-pink-800 rounded px-3 py-1 focus:outline-none focus:ring-0 focus:border-pink-300" />
                  </form>

                  <!-- Filter Form Pink -->
                  <form phx-submit="filter" class="flex gap-3 items-center">
                    <select name="filters[role]" id="role"
                      class="border border-pink-300 bg-pink-50 text-pink-800 rounded px-7 py-1
                        focus:outline-none focus:ring-0 focus:border-pink-300 focus-visible:outline-none focus-visible:ring-0">
                      <option value="all" selected={@filters["role"] == "all"}>All</option>
                      <option value="admin" selected={@filters["role"] == "admin"}>Admin</option>
                      <option value="user" selected={@filters["role"] == "user"}>User</option>
                    </select>

                    <button type="submit"
                      class="bg-pink-500 hover:bg-pink-600 text-white font-medium px-4 py-1.5 rounded shadow transition duration-200">
                      Tapis
                    </button>
                  </form>

                </div>



            <!-- Table: Users -->
            <table class="w-full table-auto border text-left shadow-md rounded-lg overflow-hidden">
              <thead class="bg-pink-100 text-pink-800 border-b border-pink-300">
                <tr>
                  <th class="px-4 py-5 text-left">Bil</th>
                  <th class="px-4 py-5 text-left min-w-[300px]">Email</th>
                  <th class="px-4 py-5 text-left min-w-[300px]">Tarikh Daftar</th>
                  <th class="px-4 py-5 text-left">Role</th>
                  <th class="px-6 py-4 text-left min-w-[200px]">Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for {user, i} <- Enum.with_index(@users, 1) do %>
                  <tr class="hover:bg-pink-50 even:bg-white odd:bg-pink-50 border-b border-pink-100">
                    <td class="px-6 py-4"><%= i %></td>
                    <td class="px-6 py-4"><%= user.email %></td>
                    <td class="px-6 py-4"><%= format_datetime(user.inserted_at) %></td>
                    <td class="px-6 py-4 capitalize"><%= user.role %></td>
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
                <.link patch={~p"/users/dashboard?#{%{role: @filters["role"], page: @page - 1}}"}>
                  <button class="px-4 py-2 bg-pink-200 rounded hover:bg-pink-300">Prev</button>
                </.link>
              <% else %>
                <span></span> <!-- Kekalkan layout kiri bila tiada Prev -->
              <% end %>

              <span class="text-sm text-gray-700">Page <%= @page %></span>

              <%= if @has_next_page do %>
                <.link patch={~p"/users/dashboard?#{%{role: @filters["role"], page: @page + 1}}"}>
                  <button class="px-4 py-2 bg-pink-200 rounded hover:bg-pink-300">Next</button>
                </.link>
              <% else %>
                <span></span> <!-- Kekalkan layout kanan bila tiada Next -->
              <% end %>
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
