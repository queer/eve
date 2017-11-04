defmodule Eve do
  @docker_url "http+unix://" <> URI.encode_www_form("/var/run/docker.sock")

  defp default_headers do
    {:ok, hostname} = :inet.gethostname
    %{"Content-Type" => "application/json", "Host" => hostname}
  end

  def get(resource, headers \\ default_headers) do
    @docker_url <> resource
    |> HTTPoison.get!(headers, [])
    |> handle_decode
  end

  defp handle_decode(%HTTPoison.Response{body: body}) do
    case Poison.decode(body) do
      {:ok, dict} -> dict
      {:error, _} -> body
    end
  end

  def get_images do
    get("/images/json")
  end

  def get_history(image) do
    get("/images/#{image}/history")
  end
end
