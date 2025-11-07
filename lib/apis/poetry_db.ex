defmodule MeuBot.Apis.PoetryDb do
  @endpoint "https://poetrydb.org/author,title/"

  def get_poema(autor, titulo) do
    autor_encoded = autor |> String.trim() |> URI.encode()
    titulo_encoded = titulo |> String.trim() |> URI.encode()

    url = "#{@endpoint}#{autor_encoded};#{titulo_encoded}"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_body(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "não encontrei esse poema. Verifique o autor e o título."}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "erro de conexão com a PoetryDB: #{reason}"}
    end
  end

  defp parse_body(body) do
    case Jason.decode(body) do
      {:ok, [primeiro_poema | _rest_of_list]} ->
        with %{"title" => title, "author" => author, "lines" => lines_list} <- primeiro_poema do
          poema_formatado = Enum.join(lines_list, "\n")

          resposta = """
          📖 **#{title}** por *#{author}*

          > #{poema_formatado}
          """

          {:ok, resposta}
        else
          _error -> {:error, "A PoetryDB retornou dados malformados."}
        end

      {:ok, %{"status" => 404, "reason" => _}} ->
        {:error, "Não encontrei esse poema. Verifique o autor e o título."}

      {:ok, []} ->
        {:error, "Não encontrei esse poema. Verifique o autor e o título."}

      _error ->
        {:error, "Não consegui processar a resposta da PoetryDB (JSON inválido)."}
    end
  end
end
