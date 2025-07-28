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

  scope "/", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :user_only]

    get "/", PageController, :home
    live "/dashboards", DashboardLive.Index, :index
    live "/dashboards/new", DashboardLive.Index, :new
    live "/dashboards/:id/edit", DashboardLive.Index, :edit

    live "/dashboards/:id", DashboardLive.Show, :show
    live "/dashboards/:id/show/edit", DashboardLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyProjectWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_project, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyProjectWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

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
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{MyProjectWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
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

  scope "/admin", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :admin_only]

    live "/dashboard", AdminDashboardLive, :index
  end

  scope "/users", MyProjectWeb do
    pipe_through [:browser, :require_authenticated_user, :user_only]

    live "/dashboard", UserDashboardLive, :index
  end

  scope "/admin", MyAppWeb do
  pipe_through :browser

  live "/dashboard", AdminDashboardLive
end
end
