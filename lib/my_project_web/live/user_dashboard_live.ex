defmodule MyProjectWeb.UserDashboardLive do
  use MyProjectWeb, :live_view

  alias MyProject.Accounts
  alias MyProject.Accounts.User

    def mount(_params, _session, socket) do
      users = MyProject.Accounts.list_users()
      {:ok,
       socket
       |> assign(:active, "dashboard")
       |> assign(:sidebar_open, true)
       |> assign(:open_settings_submenu, false)
       |> assign(:users, users)
       |> assign(:page, 1)
       |> assign_users(1)}
    end

    def mount(_params, %{"user_token" => token}, socket) do
      user = Accounts.get_user_by_session_token(token)

      {:ok,
       socket
       |> assign(:active, "dashboard")
       |> assign(:user, user)
       |> assign(:profile_changeset, Accounts.change_user_registration(user))}
    end


    defp assign_users(socket, page) do
      limit = 10
      offset = (page - 1) * limit
      users = MyProject.Accounts.paginated_users(limit, offset)

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
      user = MyProject.Accounts.get_user!(id)
      {:ok, _} = MyProject.Accounts.delete_user(user)

      users = MyProject.Accounts.list_users()

      {:noreply, assign(socket, :users, users)}
    end

    def handle_event("prev_page", _params, socket) do
      page = max(socket.assigns.page - 1, 1)
      {:noreply, assign_users(socket, page)}
    end

    def handle_event("next_page", _params, socket) do
      page = socket.assigns.page + 1
      {:noreply, assign_users(socket, page)}
    end

    def handle_event("save_profile", %{"user" => user_params}, socket) do
      case Accounts.update_user_profile(socket.assigns.user, user_params) do
        {:ok, user} ->
          {:noreply,
           socket
           |> put_flash(:info, "Profile updated successfully.")
           |> assign(:user, user)
           |> assign(:profile_changeset, Accounts.change_user_registration(user))}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :profile_changeset, changeset)}
      end
    end



  def render(assigns) do
    ~H"""
    <div class="flex h-screen w-full">
      <!-- Sidebar - Completely at Left Edge -->
        <aside class="fixed top-0 left-0 w-64 h-screen bg-pink-900 text-white shadow-lg z-40">
       <div class="p-4 border-b border-pink-700">
      <h1 class="text-2xl font-bold mb-6">User Panel</h1>
      </div>

      <a href="#" phx-click="nav" phx-value-id="dashboard"
         class={"block px-4 py-2 rounded " <> if @active == "dashboard", do: "bg-pink-900", else: "hover:bg-gray-700"}>
        Dashboard
      </a>


      <!-- Submenu -->
      <div>
        <button phx-click="toggle_submenu" phx-value-id="settings"
                class="flex items-center justify-between w-full px-4 py-2 rounded hover:bg-gray-700">
          <span>Tetapan</span>
          <svg class="w-4 h-4 ml-2 transform transition-transform duration-300"
               fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
          </svg>
        </button>
        </div>

        <div class={"mt-1 ml-4 space-y-1 " <> if @open_settings_submenu, do: "block", else: "hidden"}>
          <a href="#" phx-click="nav" phx-value-id="profile"
             class="block px-2 py-1 rounded hover:bg-gray-600 text-sm">
            Profil
          </a>
          <a href="#" phx-click="nav" phx-value-id="password"
             class="block px-2 py-1 rounded hover:bg-gray-600 text-sm">
            Tukar Kata Laluan
          </a>
        </div>
    </aside>

    <!-- Main Content -->
    <div class="flex min-h-screen bg-gray-100">
      <!-- Hamburger Button -->
      <button class="md:hidden mb-4" phx-click="toggle_sidebar">
        <svg class="w-6 h-6 text-gray-800" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M4 6h16M4 12h16M4 18h16"/>
        </svg>
      </button>
     </div>

      <!-- Content -->
      <%= if @active == "dashboard" do %>
  <div class="bg-pink p-6 rounded shadow w-full max-w-none mx-auto">

    <h2 class="text-xl font-bold mb-4 mt-2">Senarai Email Aktif</h2>

    <table class="w-full table-auto border text-sm">
      <thead class="bg-gray-100">
        <tr>
          <th class="px-4 py-5 text-left">#</th>
          <th class="px-4 py-5 text-left">Email</th>
          <th class="px-4 py-5 text-left">Tarikh Daftar</th>
          <th class="px-6 py-4 text-left">Actions</th>
        </tr>
      </thead>
      <tbody>
        <%= for {user, i} <- Enum.with_index(@users, 1) do %>
          <tr class="hover:bg-gray-50">
            <td class="px-6 py-4"><%= i %></td>
            <td class="px-6 py-4"><%= user.email %></td>
            <td class="px-6 py-4"><%= format_datetime(user.inserted_at) %></td>
            <td class="px-6 py-4 space-x-2">
             <!-- Butang edit -->
             <a href={~p"/users/#{user.id}/edit"} class="text-blue-600 hover:underline">Edit</a>

             <!-- Butang Delete -->
             <button phx-click="delete_user" phx-value-id={user.id} class="text-red-600 hover:underline">
              Delete
              </button>
            </td>
          </tr>
        <% end %>
        </tbody>
     </table>

     <!-- Pagination buttons start here -->
    <div class="mt-6 flex justify-between items-center">
  <button
    class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
    phx-click="prev_page"
    disabled={@page == 1}>
    Prev
  </button>

  <span class="text-sm text-gray-700">Page <%= @page %></span>

    <button
    class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
    phx-click="next_page">
    Next
    </button>
   </div>
   <!-- Pagination button end here -->
  </div>
    <% end %>

    <%= if @active == "profile" do %>
  <div class="bg-white p-6 rounded shadow w-full max-w-2xl mx-auto mt-6">
    <h2 class="text-xl font-bold mb-4">Kemaskini Profil</h2>

    <.form
      for={@profile_changeset}
      id="profile-form"
      phx-change="validate"
      phx-submit="save_profile"
      class="space-y-4"
      let={f}
      >

      <!-- Nama -->
      <div>
        <%= label f, :name, "Nama" %>
        <%= text_input f, :name %>
      </div>

      <!-- Umur -->
      <div>
        <%= label f, :age, "Umur" %>
        <%= number_input f, :age %>
      </div>

      <!-- IC -->
      <div>
        <%= label f, :ic, "No Kad Pengenalan" %>
        <%= text_input f, :ic %>
      </div>

      <!-- Gambar Profil -->
      <div>
        <%= label f, :avatar, "Gambar Profil", class: "block font-medium" %>
        <%= file_input f, :avatar, class: "input w-full" %>
      </div>

      <div>
        <%= submit "Simpan", class: "bg-blue-500 text-white px-4 py-2 rounded" %>
      </div>
    </.form>
  </div>
   <% end %>


      <%= if @active == "password" do %>
        <div class="bg-white p-6 rounded shadow"> Tukar kata laluan</div>
      <% end %>
      </div>
  """
      end

      defp format_datetime(nil), do: "-"
      defp format_datetime(dt), do: Calendar.strftime(dt, "%d-%m-%Y %H:%M")

end
