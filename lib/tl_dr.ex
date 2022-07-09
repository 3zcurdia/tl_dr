defmodule TLDR do
  @moduledoc """
  Documentation for `TLDR`.
  """
  alias TLDR.OpenAI

  @doc """
  It sumarizes the content witing the given options.

  ## Examples

        iex> TLDR.summarize("Hello, world! is a basic computer program commonly used as a first step into programming")
        {:ok, "Hello, world! is a basic computer program"}

  it also could recieve a list of text to summarize:

        iex> texts = ["Hello, world! is a basic computer program commonly used as a first step into programming", "Hello, world! is a basic computer program commonly used as a first step into programming"]
        iex> TLDR.summarize(texts)
        {:ok, ["Hello, world! is a basic computer program", "Hello, world! is a basic computer program"]}

  By default it generates a context for the OpenAI using the ENV variable OPENAI_ACCESS_TOKEN and the engine text-babbage-001.
  But you can override this behavior by passing your own context.

        iex> context = TLDR.OpenAI.Context.build("my_access_token", "my_engine")
        iex> TLDR.summarize("Hello, world! is a basic computer program commonly used as a first step into programming", context: context)
        {:ok, "Hello, world! is a basic computer program"}
  """
  @spec summarize(list | String.t(), keyword) :: {atom, list | String.t()}
  def summarize(content, options \\ [context: OpenAI.Context.build()])

  def summarize(content, options) when is_list(content) do
    results =
      content
      |> Task.async_stream(
        fn str -> summarize(str, options) end,
        max_concurrency: OpenAI.Client.pool_size()
      )
      |> Enum.filter(fn {status, _result} -> status == :ok end)
      |> Enum.map_reduce([], fn {_, result} -> result end)

    if Enum.empty?(results) do
      {:error, "No results found"}
    else
      {:ok, results}
    end
  end

  def summarize(content, context: context) when is_binary(content) do
    context
    |> OpenAI.Client.completion(%{prompt: "#{content}\n tl;dr:", temperature: 0.4})
    |> extract_choices_text()
  end

  defp extract_choices_text({:ok, %{"choices" => [%{"text" => text} | _]}}),
    do: {:ok, String.trim(text)}

  defp extract_choices_text(any), do: any
end
