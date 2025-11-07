defmodule MeuBot.Apis.CleanUri do
  @endpoint "https://cleanuri.com/api/v1/shorten"

  def shorten_url(url_longa) do
    body = {:form, [url: url_longa]}

    case HTTPoison.post(@endpoint, body) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_body(body)

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:error, "parece que essa não é uma URL válida. Tente novamente.."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "erro de conexão com CleanURI: #{reason}."}
    end
  end

  defp parse_body(body) do
    with {:ok, json} <- Jason.decode(body),
         %{"result_url" => short_url} <- json do
      {:ok, "URL encurtdada: #{short_url}"}
    else
      _error -> {:error, "Não consegui processar a resposta da API CleanURI."}
    end
  end
end
