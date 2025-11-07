defmodule MeuBot.DiscordClient do
  use Nostrum.Consumer

  alias MeuBot.Apis.CatholicCalendar
  alias MeuBot.Apis.CoinCap
  alias MeuBot.Apis.CleanUri
  alias MeuBot.Apis.RiotGames
  alias MeuBot.Apis.PoetryDb
  alias Nostrum.Api

  def handle_event({:MESSAGE_CREATE, message, _ws_state}) do
    unless message.author.bot do
      case message.content do
        "!santododia" ->
          case CatholicCalendar.get_santo_do_dia() do
            {:ok, resposta} ->
              Api.Message.create(message.channel_id, resposta)

            {:error, erro_msg} ->
              Api.Message.create(message.channel_id, "Deu ruim, mestre: #{erro_msg}")
          end

        "!crypto" <> crypto_id ->
          case CoinCap.get_crypto_price(String.trim(crypto_id)) do
            {:ok, resposta} ->
              Api.Message.create(message.channel_id, resposta)

            {:error, erro_msg} ->
              Api.Message.create(message.channel_id, "Deu ruim, mestre: #{erro_msg}")
          end

        "!encurtar" <> url ->
          case CleanUri.shorten_url(String.trim(url)) do
            {:ok, resposta} ->
              Api.Message.create(message.channel_id, resposta)

            {:error, erro_msg} ->
              Api.Message.create(message.channel_id, "Deu ruim, mestre: #{erro_msg}")
          end

        "!lol" <> params ->
          params = String.trim(params)

          case String.split(params, " ", parts: 2) do
            [region, riot_id] ->
              case RiotGames.get_summoner(region, String.trim(riot_id)) do
                {:ok, resposta} ->
                  Api.Message.create(message.channel_id, resposta)

                {:error, erro_msg} ->
                  Api.Message.create(message.channel_id, "Deu ruim, mestre: #{erro_msg}")
              end

            _ ->
              Api.Message.create(
                message.channel_id,
                "Uso correto: `!lol <região> <nome>#<tag>` (ex: `!lol br1 Kyohisuru#BR1`)"
              )
          end

        "!poema " <> params ->
          case String.split(params, ";", parts: 2) do
            [autor, titulo] ->
              case PoetryDb.get_poema(autor, titulo) do
                {:ok, resposta} -> Api.Message.create(message.channel_id, resposta)
                {:error, erro_msg} -> Api.Message.create(message.channel_id, erro_msg)
              end

            _ ->
              Api.Message.create(
                message.channel_id,
                "Formato errado. Use: `!poema <autor>; <titulo>`"
              )
          end

        _ ->
          :ignore
      end
    end
  end

  def handle_event(_event), do: :noop
end
