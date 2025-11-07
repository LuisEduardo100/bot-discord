defmodule MeuBot.Apis.RiotGames do
  @account_base "api.riotgames.com/riot/account/v1/accounts/by-riot-id/"
  @summoner_base "api.riotgames.com/lol/summoner/v4/summoners/by-puuid/"

  @region_map %{
    "br1" => "americas",
    "na1" => "americas",
    "la1" => "americas",
    "la2" => "americas",
    "oc1" => "americas",
    "euw1" => "europe",
    "eun1" => "europe",
    "tr1" => "europe",
    "ru" => "europe",
    "kr" => "asia",
    "jp1" => "asia"
  }

  def get_summoner(region, riot_id) do
    region_key = String.downcase(String.trim(region))
    platform = Map.get(@region_map, region_key)

    if platform do
      case String.split(riot_id, "#", parts: 2) do
        [game_name, tag_line] ->
          name_encoded = URI.encode_www_form(game_name)
          tag_encoded = URI.encode_www_form(tag_line)
          api_key = Application.fetch_env!(:meu_bot, :riot_api_key)
          headers = [{"X-Riot-Token", api_key}]

          url = "https://#{platform}.#{@account_base}#{name_encoded}/#{tag_encoded}"

          case HTTPoison.get(url, headers) do
            {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
              with {:ok, %{"puuid" => puuid, "gameName" => name, "tagLine" => tag}} <-
                     Jason.decode(body) do
                get_summoner_details(region_key, name, tag, puuid, headers)
              else
                _ -> {:error, "Não consegui interpretar os dados da conta Riot."}
              end

            {:ok, %HTTPoison.Response{status_code: code}} ->
              {:error, "A Riot retornou status #{code}. Verifique o nome/tag e a região."}

            {:error, %HTTPoison.Error{reason: reason}} ->
              {:error, "Erro de conexão com a Riot API: #{reason}"}
          end

        _ ->
          {:error, "Formato inválido. Use `Nome#Tag` (ex: Kyohisuru#BR1)."}
      end
    else
      {:error, "Região `#{region}` inválida. Use, por exemplo: `br1`, `na1`, `kr`, `euw1`, etc."}
    end
  end

  defp get_summoner_details(region, name, tag, puuid, headers) do
    url = "https://#{region}.#{@summoner_base}#{puuid}"

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        with {:ok, %{"summonerLevel" => level}} <- Jason.decode(body) do
          {:ok,
           "🎮 Invocador: **#{name}##{String.upcase(tag)}** (#{String.upcase(region)}) está no Nível **#{level}**."}
        else
          _ -> {:error, "Não consegui obter o nível do invocador."}
        end

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Erro ao buscar detalhes do invocador (status #{code})."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Erro de conexão ao buscar detalhes do invocador: #{reason}"}
    end
  end
end
