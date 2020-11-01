defmodule ZeitWeb.Router do
  use ZeitWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ZeitWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :public do
    plug ZeitWeb.Middleware.AuthContext
  end

  pipeline :protected do
    plug ZeitWeb.Middleware.AuthRequired
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ZeitWeb do
    pipe_through [:browser, :public]
    get "/", PageController, :login
    get "/logout", AuthController, :logout
  end

  scope "/", ZeitWeb do
    pipe_through [:browser, :public, :protected]

    live "/sites", SiteLive.Index, :index
    live "/sites/new", SiteLive.Index, :new
    live "/sites/import", SiteLive.Index, :import_sites
    live "/sites/report", ReportLive.Index, :index
    live "/sites/:id/edit", SiteLive.Index, :edit
    live "/sites/:id/add-links", SiteLive.Index, :add_links

    live "/sites/:id", SiteLive.Show, :show
    live "/sites/:id/show/edit", SiteLive.Show, :edit
    live "/sites/:id/diff/:link_id/:timestamp", SiteLive.Show, :diff

    # Proxies
    live "/proxies", ProxyLive.Index, :index
    live "/proxies/new", ProxyLive.Index, :new
    live "/proxies/:id/edit", ProxyLive.Index, :edit
  end

  # Auth scope
  scope "/login", ZeitWeb do
    pipe_through [:browser, :public]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :login
  end

  # Other scopes may use custom stacks.
  # scope "/api", ZeitWeb do
  #   pipe_through :api
  # end
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ZeitWeb.Telemetry
    end
  end
end
