defmodule ElixirHttpbin.PageController do
  use ElixirHttpbin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
