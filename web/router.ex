defmodule ElixirHttpbin.Router do
  use ElixirHttpbin.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ElixirHttpbin do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  #Routes for redirects
  scope "/", ElixirHttpbin do

    get "/xml", RedirectController, :xml
    get "/html", RedirectController, :html
  end

  # Other scopes may use custom stacks.
  scope "/", ElixirHttpbin do
    pipe_through :api

    get "/ip", APIController, :ip
    get "/user-agent", APIController, :user_agent
    get "/headers", APIController, :headers
    get "/get", APIController, :get
  end
end
