defmodule BlockScoutWeb.Resolvers.Transaction do
  @moduledoc false

  require Logger
  
  alias Absinthe.Relay.Connection
  alias Explorer.{Chain, GraphQL, Repo}
  alias Explorer.Chain.Address

  def get_by(_, %{hash: hash}, _) do
    Logger.info(fn -> [ "#####get_by"] end)
    case Chain.hash_to_transaction(hash) do
      {:ok, transaction} -> {:ok, transaction}
      {:error, :not_found} -> {:error, "Transaction not found."}
    end
  end

  def get_by(%Address{hash: address_hash}, args, _) do
    address_hash
    |> GraphQL.address_to_transactions_query()
    |> Connection.from_query(&Repo.all/1, args, options(args))
  end

  defp options(%{before: _}), do: []

  defp options(%{count: count}), do: [count: count]

  defp options(_), do: []
end
