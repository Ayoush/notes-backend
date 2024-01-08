defmodule Notes.Models.Helpers do
  def paginated_response(data, pagination_data) do
    %{
      entries: data,
      page_number: pagination_data.page_number,
      page_size: pagination_data.page_size,
      total_entries: pagination_data.total_entries,
      total_pages: pagination_data.total_pages
    }
  end

  def from_struct_to_map(map), do: :maps.map(&from_struct_to_map/2, map)

  def from_struct_to_map(_key, value), do: ensure_nested_map(value)

  defp ensure_nested_map(list) when is_list(list), do: Enum.map(list, &ensure_nested_map/1)

  # NOTE: In pattern-matching order of function guards is important!
  # @structs [Date, DateTime, NaiveDateTime, Time]
  # defp ensure_nested_map(%{__struct__: struct} = data) when struct in @structs, do: data

  defp ensure_nested_map(%{__struct__: _} = struct) do
    map = Map.from_struct(struct)
    :maps.map(&from_struct_to_map/2, map)
  end

  defp ensure_nested_map(data), do: data
end
