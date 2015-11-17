defmodule ElixirHttpbin.PageController do
  use ElixirHttpbin.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def html(conn, _params) do
    conn
    |> put_layout(false)
    |> render "html.html"
  end

  def xml(conn, _params) do
    case File.read(Application.get_env(:elixir_httpbin, :xml_file)) do
      {:ok, file} ->
        conn
          |> put_resp_content_type("application/xml")
          |> send_resp(200, file)
      {:error, something} -> text conn, "ERROR: #{something}"
    end
  end
end
