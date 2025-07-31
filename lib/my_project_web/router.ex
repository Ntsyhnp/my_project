defmodule MyProjectWeb.Router do
  use MyProjectWeb, :router

  import MyProjectWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyProjectWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # =============================
  # ✅ PUBLIC / AUTH PAGES
  # =============================
  scope "/", MyProjectWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{MyProjectWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", MyProjectWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{MyProjectWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # =============================
  # ✅ USER-ONLY ROUTES
  # =============================
  scope "/users", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :user_only]

    live_session :user_only,
      on_mount: [{MyProjectWeb.UserAuth, :ensure_authenticated}] do
      live "/dashboard", UserDashboardLive
      live "/settings", UserSettingsLive, :edit
      live "/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  # =============================
  # ✅ ADMIN-ONLY ROUTES
  # =============================
  scope "/admin", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :admin_only]

    live_session :admin_only,
      on_mount: [{MyProjectWeb.UserAuth, :ensure_authenticated}] do
      live "/dashboard", AdminDashboardLive
    end
  end

  # =============================
  # ✅ CATCH-ALL ROUTE (Example Home Page)
  # =============================
  scope "/", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :user_only]

    get "/", PageController, :home
  end

  # =============================
  # ✅ DEV TOOLS
  # =============================
  if Application.compile_env(:my_project, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyProjectWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
