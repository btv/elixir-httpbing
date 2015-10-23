defmodule ElixirHttpbin.APIController do
  use ElixirHttpbin.Web, :controller

  defp ip_address_as_string(conn) do
    to_string :inet_parse.ntoa(conn.remote_ip)
  end

  defp headers_as_map(conn) do
    Enum.into(conn.req_headers, %{})
  end

  def ip(conn, _params) do
    json conn, %{origin: ip_address_as_string(conn)}
  end

  def user_agent(conn, _params) do
    json conn, %{"user-agent": Plug.Conn.get_req_header(conn, "user-agent")}
  end

  def headers(conn, _params) do
    json conn, %{headers: headers_as_map(conn)}
  end

  def get(conn, _params) do
    local_host = Plug.Conn.get_req_header(conn, "host")
    local_args = conn.query_string
      |> String.split("&")

    json conn, %{
      "url": "#{to_string conn.scheme}://#{local_host}#{conn.request_path}",
      "headers": headers_as_map(conn),
      "origin": ip_address_as_string(conn),
      "args": local_args
    }
  end
end
