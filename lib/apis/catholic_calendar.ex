defmodule MeuBot.Apis.CatholicCalendar do
  @endpoint "http://calapi.inadiutorium.cz/api/v0/en/calendars/default/tomorrow"

  def get_santo_do_dia do
    case HTTPoison.get(@endpoint) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> parse_body(body)
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "não encontrei dados para hoje."}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, "erro de conexão: #{reason}"}
    end
  end

  defp parse_body(body) do
    with {:ok, json} <- Jason.decode(body),
         %{"celebrations" => celebrations_list} <- json do
      celebracao_do_santo =
        Enum.find(celebrations_list, fn celebration ->
          title_lower = String.downcase(celebration["title"])
          not (String.contains?(title_lower, "week") or String.contains?(title_lower, "semana"))
        end)

      celebration_to_use = celebracao_do_santo || List.first(celebrations_list)

      with %{"title" => title, "colour" => color} <- celebration_to_use do
        cor_liturgica =
          case color do
            "green" -> "Verde"
            "white" -> "Branco"
            "red" -> "Vermelho"
            "violet" -> "Roxo"
            _ -> color
          end

        {:ok, "Hoje celebramos: **#{title}**. Cor litúrgica: #{cor_liturgica}."}
      else
        _ -> {:error, "Não consegui processar a resposta do Calendário (Passo 2)."}
      end
    else
      _error -> {:error, "Não consegui processar a resposta da API de calendário (Passo 1)."}
    end
  end
end
