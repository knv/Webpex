defmodule WebpexWeb.Router do
  use WebpexWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :img do
    plug :accepts, ["webp", "jpg", "png"]
  end

  scope "/", WebpexWeb do
    pipe_through :img

    get "/image/:image_id", ImageController, :show
  end

  scope "/api", WebpexWeb.API, as: :api do
    pipe_through :api

    scope "/v1", V1, as: :v1 do
      resources "/images", APIController, only: [:create, :delete]
    end
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:webpex, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: WebpexWeb.Telemetry
    end
  end
end
