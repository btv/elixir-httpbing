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
    require Integer

    local_host = Plug.Conn.get_req_header(conn, "host")
    local_args = conn.query_string
      |> String.split(["&", "="])

    case length(local_args) do
      x when Integer.is_even(x) == false ->
        #TODO: return 404
        future_args = ["ERROR", "PARSING", "ARGS"]
      x when x == 2 ->
        [h,i] = local_args
        future_args = Map.put(%{}, h, i)
      _ ->
        future_args = Map.new
        future_list = Enum.chunk(local_args, 2)
          |> Enum.map( fn([h,i]) -> Map.put(%{}, h, [i]) end)

        future_args = List.foldl(future_list, future_args,
          fn(m,acc) -> Map.merge(m, acc,
            fn(_k, v1, v2) -> List.flatten([v2,v1]) end)
          end)
      end

    json conn, %{
      "url": "#{to_string conn.scheme}://#{local_host}#{conn.request_path}",
      "headers": headers_as_map(conn),
      "origin": ip_address_as_string(conn),
      "args": future_args
    }
  end

  def xml(conn, _params) do
    case File.read("/Users/bverdier/programming/github/elixir-httpbing/web/static/sample.xml") do
      {:ok, file} ->
        conn
          |> put_resp_content_type("application/xml")
          |> send_resp(200, file)
      {:error, reason} -> text conn, "ERROR: #{reason}"
    end
  end
end
