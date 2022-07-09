defmodule TLDR.OpenAI.Client do
  @moduledoc """
  This module is a basic client for the OpenAI API.
  """
  alias Finch.Response

  def pool_size, do: 20

  def child_spec do
    {Finch,
     name: __MODULE__,
     pools: %{
       "https://api.openai.com/" => [size: pool_size()]
     }}
  end

  def completion(%{engine: engine} = context, body) do
    url = "https://api.openai.com/v1/engines/#{engine}/completions"

    :post
    |> Finch.build(url, build_headers(context), Jason.encode!(body))
    |> Finch.request(__MODULE__)
    |> json_response()
  end

  defp build_headers(%{access_token: access_token}) do
    %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}"
    }
  end

  defp json_response({:ok, %Response{status: status, body: body}}) do
    case status do
      code when code in 200..299 -> Jason.decode(body)
      _ -> {:error, Jason.decode!(body)}
    end
  end

  defp json_response(any), do: any
end
