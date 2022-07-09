defmodule TLDR.OpenAI.Context do
  @moduledoc """
  This module is a basic context for the OpenAI API.
  """
  defstruct [:access_token, :engine]

  alias TLDR.OpenAI.Context

  def build(access_token \\ System.get_env("OPENAI_ACCESS_TOKEN"), engine \\ "text-babbage-001")

  def build(access_token, engine) do
    %Context{access_token: access_token, engine: engine}
  end
end
