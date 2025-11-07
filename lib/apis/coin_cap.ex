defmodule MeuBot.Apis.CoinCap do
  @endpoint "https://rest.coincap.io/v3/assets/"

  def get_crypto_price(crypto_id) do
    url = @endpoint <> String.downcase(crypto_id)
    key = Application.fetch_env!(:meu_bot, :coin_cap_key)
    headers = [Authorization: "Bearer #{key}"]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_body(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "não consegui encontrar a criptomoeda '#{crypto_id}'"}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, "você não tem autorização para acessar a API."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão com a CoinCap: #{reason}"}
    end
  end

  defp parse_body(body) do
    with {:ok, json} <- Jason.decode(body),
         %{"data" => data} <- json,
         %{"priceUsd" => price, "symbol" => symbol} <- data do
      price = Float.parse(price) |> elem(0)
      price_formatted = :erlang.float_to_binary(price, decimals: 2)

      {:ok, "**#{symbol}**: $ #{price_formatted} USD"}
    else
      _error -> {:error, "Não consegui processar a resposta da API CoinCap"}
    end
  end
end
