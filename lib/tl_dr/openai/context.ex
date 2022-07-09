defmodule TLDR.OpenAI.Context do
  @moduledoc """
  This module is a basic context for the OpenAI API.
  """
  defstruct [:access_token, :engine]

  alias TLDR.OpenAI.Context

  @doc """
  It build the context using the given options.

  ## Example

  With all parameters

           iex> TLDR.OpenAI.Context.build("my_access_token", "my_engine")
           %TLDR.OpenAI.Context{access_token: "my_access_token", engine: "my_engine"}

  With only the access_token

           iex> TLDR.OpenAI.Context.build("my_access_token")
           %TLDR.OpenAI.Context{access_token: "my_access_token", engine: "text-babbage-001"}

  Without any arguments it will use the environment variables OPENAI_ACCESS_TOKEN and text-babbage-001.
  """
  @spec build(String.t(), String.t()) :: struct
  def build(access_token \\ System.get_env("OPENAI_ACCESS_TOKEN"), engine \\ "text-babbage-001")

  def build(access_token, engine) do
    %Context{access_token: access_token, engine: engine}
  end
end
