defmodule MyProjectWeb.UserLoginLive do
  use MyProjectWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Log in to account
        <:subtitle>
          Don't have an account?
          <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
            Sign up
          </.link>
          for an account now.
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
            Forgot your password?
          </.link>
        </:actions>
        <:actions>
          <.button phx-disable-with="Logging in..." class="w-full">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end

  def handle_event("login", %{"user" => %{"email" => email, "password" => password}}, socket) do
    case MyProject.Accounts.get_user_by_email_and_password(email, password) do
      {:ok, user} ->
        {:noreply,
      socket
      |> put_flash(:info, "Welcome back!")
      |> redirect(to: get_dashboard_path(user))}

      {:error, _reason} ->
      {:noreply,
      socket
      |> put_flash(:error, "Invalid email or password")
      |> assign(:form, to_form(%{}, as: "user"))}
    end
  end

  defp get_dashboard_path(%{role: "admin"}), do: "/admin/dashboard"
  defp get_dashboard_path(_), do: "/dashboard"
end
