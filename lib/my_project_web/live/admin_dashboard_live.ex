defmodule MyProjectWeb.AdminDashboardLive do
  use MyProjectWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="flex h-screen w-full">
      <!-- Sidebar - Completely at Left Edge -->
      <aside class="fixed top-0 left-0 w-64 h-screen bg-gray-900 text-white shadow-lg z-40">
        <div class="p-4 border-b border-gray-700">
          <h1 class="text-xl font-bold text-white">Admin Dashboard</h1>
        </div>

        <nav class="p-4">
          <div class="space-y-2">
            <a href="#"
               phx-click="nav"
               phx-value-id="dashboard"
               class={"flex items-center px-4 py-3 rounded-lg transition-colors " <>
                      if @active == "dashboard", do: "bg-blue-600 text-white font-semibold", else: "text-gray-300 hover:bg-gray-700 hover:text-white"}>
              <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2H5a2 2 0 00-2-2z"></path>
              </svg>
              Dashboard
            </a>

            <a href="#"
               phx-click="nav"
               phx-value-id="users"
               class={"flex items-center px-4 py-3 rounded-lg transition-colors " <>
                      if @active == "users", do: "bg-blue-600 text-white font-semibold", else: "text-gray-300 hover:bg-gray-700 hover:text-white"}>
              <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z"></path>
              </svg>
              Pengguna
            </a>

            <a href="#"
               phx-click="nav"
               phx-value-id="reports"
               class={"flex items-center px-4 py-3 rounded-lg transition-colors " <>
                      if @active == "reports", do: "bg-blue-600 text-white font-semibold", else: "text-gray-300 hover:bg-gray-700 hover:text-white"}>
              <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2-2v-6a2 2 0 012-2h2a2 2 0 012 2v6a2 2 0 002 2h2a2 2 0 012-2v6a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
              </svg>
              Laporan
            </a>

            <a href="#"
               phx-click="nav"
               phx-value-id="settings"
               class={"flex items-center px-4 py-3 rounded-lg transition-colors " <>
                      if @active == "settings", do: "bg-blue-600 text-white font-semibold", else: "text-gray-300 hover:bg-gray-700 hover:text-white"}>
              <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
              </svg>
              Tetapan
            </a>
          </div>
        </nav>
      </aside>

      <!-- Main Content - Full Width on Right Side -->
       <main class="ml-1 h-screen overflow-y-auto bg-gray-50 p-15">
        <div class="p-15 w-full">
          <!-- Dashboard Section -->
          <%= if @active == "dashboard" do %>
            <div class="bg-white rounded-lg shadow-md p-15 h-full">
              <h2 class="text-2xl font-bold text-gray-800 mb-6">Dashboard</h2>
              <div class="grid grid-cols-1 md:grid-cols-3 gap-6 h-full">
                <div class="bg-blue-50 p-6 rounded-lg flex flex-col justify-center">
                  <h3 class="font-semibold text-blue-800 mb-4">Jumlah Pengguna</h3>
                  <p class="text-3xl font-bold text-blue-600">1,234</p>
                </div>
                <div class="bg-green-50 p-6 rounded-lg flex flex-col justify-center">
                  <h3 class="font-semibold text-green-800 mb-4">Aktiviti Hari Ini</h3>
                  <p class="text-3xl font-bold text-green-600">567</p>
                </div>
                <div class="bg-purple-50 p-6 rounded-lg flex flex-col justify-center">
                  <h3 class="font-semibold text-purple-800 mb-4">Laporan Baru</h3>
                  <p class="text-3xl font-bold text-purple-600">89</p>
                </div>
              </div>
            </div>
          <% end %>

          <!-- Users Section -->
          <%= if @active == "users" do %>
            <div class="bg-white rounded-lg shadow-md p-6 w-full">
              <h2 class="text-2xl font-bold text-gray-800 mb-6">Pengurusan Pengguna</h2>
              <div class="overflow-y-auto h-full">
                <table class="min-w-full table-auto">
                  <thead class="bg-gray-50 sticky top-0">
                    <tr>
                      <th class="px-6 py-4 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                      <th class="px-6 py-4 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Email</th>
                      <th class="px-6 py-4 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Status</th>
                      <th class="px-6 py-4 text-left text-sm font-medium text-gray-500 uppercase tracking-wider">Tindakan</th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Ahmad Ali</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">ahmad@example.com</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Aktif</span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="#" class="text-indigo-600 hover:text-indigo-900">Edit</a>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Siti Aminah</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">siti@example.com</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">Tidak Aktif</span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="#" class="text-indigo-600 hover:text-indigo-900">Edit</a>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Mohd Rahman</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">rahman@example.com</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Aktif</span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="#" class="text-indigo-600 hover:text-indigo-900">Edit</a>
                      </td>
                    </tr>
                    <tr>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">Fatimah Binti</td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">fatimah@example.com</td>
                      <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Aktif</span>
                      </td>
                      <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                        <a href="#" class="text-indigo-600 hover:text-indigo-900">Edit</a>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          <% end %>

          <!-- Reports Section -->
          <%= if @active == "reports" do %>
            <div class="bg-white rounded-lg shadow-md p-6 max-w-full">
              <h2 class="text-2xl font-bold text-gray-800 mb-6">Laporan Sistem</h2>
              <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 h-full">
                <div class="border border-gray-200 rounded-lg p-6 flex flex-col justify-center">
                  <h3 class="font-semibold text-gray-800 mb-4">Laporan Bulanan</h3>
                  <p class="text-gray-600 mb-6 flex-1">Laporan aktiviti pengguna untuk bulan ini dengan statistik terperinci dan analisis mendalam</p>
                  <button class="bg-blue-500 text-white px-6 py-3 rounded hover:bg-blue-600">Muat Turun</button>
                </div>
                <div class="border border-gray-200 rounded-lg p-6 flex flex-col justify-center">
                  <h3 class="font-semibold text-gray-800 mb-4">Laporan Tahunan</h3>
                  <p class="text-gray-600 mb-6 flex-1">Laporan prestasi sistem untuk tahun ini dengan analisis mendalam dan trend analysis</p>
                  <button class="bg-green-500 text-white px-6 py-3 rounded hover:bg-green-600">Muat Turun</button>
                </div>
              </div>
            </div>
          <% end %>

          <!-- Settings Section -->
          <%= if @active == "settings" do %>
            <div class="bg-white rounded-lg shadow-md w-full h-full">
              <h2 class="text-2xl font-bold text-gray-800 mb-6">Tetapan Sistem</h2>
              <div class="max-w-2xl space-y-6">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Nama Sistem</label>
                  <input type="text" value="MyProject Admin" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Email Admin</label>
                  <input type="email" value="admin@myproject.com" class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-2">Zon Masa</label>
                  <select class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option>Asia/Kuala_Lumpur</option>
                    <option>UTC</option>
                    <option>America/New_York</option>
                  </select>
                </div>
                <div class="flex-1"></div>
                <button class="bg-blue-500 text-white px-6 py-3 rounded-md hover:bg-blue-600">Simpan Tetapan</button>
              </div>
            </div>
          <% end %>
        </div>
      </main>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, active: "dashboard")}
  end

  def handle_event("nav", %{"id" => section_id}, socket) do
    {:noreply, assign(socket, :active, section_id)}
  end
end
