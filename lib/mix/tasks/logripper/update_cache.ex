defmodule Mix.Tasks.Logripper.UpdateCache do
  use Mix.Task

  import Ecto.Query, only: [from: 2]

  alias ExAws.S3
  alias Logripper.CloudfrontLog
  alias Logripper.Repo

  @bucket "system76-logs"

  def run(_args) do
    {:ok, _} = Application.ensure_all_started(:hackney)
    {:ok, _} = Application.ensure_all_started(:mariaex)
    {:ok, _} = Application.ensure_all_started(:ecto)

    Repo.start_link

    import_logs()
  end

  defp import_logs(marker \\ nil) do
    result = S3.list_objects(@bucket, marker: marker, prefix: "system76-cdn/") |> ExAws.request!
    log_files = result.body.contents

    Enum.each result.body.contents, fn log_object ->
      import_log(log_object.key)
    end

    if result.body.is_truncated do
      next_marker = hd(Enum.reverse(result.body.contents)).key
      import_logs(next_marker)
    end
  end

  defp import_log(key) do
    IO.write "Importing \"#{key}\"..."

    file_already_parsed? =
      Repo.exists? from f in "cloudfront_log_files", where: f.filename == ^key

    if file_already_parsed? do
      IO.puts "Skip"
    else
      result = S3.get_object(@bucket, key) |> ExAws.request!
      data = :zlib.gunzip(result.body)

      import_data(key, data)

      IO.puts "Done!"
    end
  end

  defp import_data(key, log_data) do
    log_entries =
      log_data
      |> String.split("\n")
      |> Enum.reject(&(&1 == ""))
      |> Enum.reject(&String.starts_with?(&1, "#"))
      |> CSV.decode(separator: ?\t)

    log_objects = Enum.map(log_entries, &parse_log_entry/1)

    Repo.transaction(fn ->
      Enum.each(log_objects, &Repo.insert!(&1, timeout: :infinity))
      Repo.insert_all("cloudfront_log_files", [%{filename: key}], timeout: :infinity)
    end, timeout: :infinity)
  end

  defp parse_log_entry({:ok, [
    date,
    time,
    x_edge_location,
    sc_bytes,
    c_ip,
    cs_method,
    cs_host,
    cs_uri_stem,
    sc_status,
    cs_referer,
    cs_user_agent,
    cs_uri_query,
    cs_cookie,
    x_edge_result_type,
    x_edge_request_id,
    x_host_header,
    cs_protocol,
    cs_bytes,
    time_taken,
    x_forwarded_for,
    ssl_protocol,
    ssl_cipher,
    x_edge_response_result_type,
    cs_protocol_version,
  ]}) do
    parse_log_entry({:ok, [
      date,
      time,
      x_edge_location,
      sc_bytes,
      c_ip,
      cs_method,
      cs_host,
      cs_uri_stem,
      sc_status,
      cs_referer,
      cs_user_agent,
      cs_uri_query,
      cs_cookie,
      x_edge_result_type,
      x_edge_request_id,
      x_host_header,
      cs_protocol,
      cs_bytes,
      time_taken,
      x_forwarded_for,
      ssl_protocol,
      ssl_cipher,
      x_edge_response_result_type,
      cs_protocol_version,
      "-",
      "-"
    ]})
  end

  defp parse_log_entry({:ok, [
    date,
    time,
    x_edge_location,
    sc_bytes,
    c_ip,
    cs_method,
    cs_host,
    cs_uri_stem,
    sc_status,
    cs_referer,
    cs_user_agent,
    cs_uri_query,
    cs_cookie,
    x_edge_result_type,
    x_edge_request_id,
    x_host_header,
    cs_protocol,
    cs_bytes,
    time_taken,
    x_forwarded_for,
    ssl_protocol,
    ssl_cipher,
    x_edge_response_result_type,
    cs_protocol_version,
    _fle_status,
    _fle_encrypted_fields
  ]}) do
    {:ok, timestamp} = NaiveDateTime.new(
      Date.from_iso8601!(date),
      Time.from_iso8601!(time)
    )

    sc_bytes =
      try do
        String.to_integer(sc_bytes)
      rescue ArgumentError ->
        nil
      end

    sc_status =
      try do
        String.to_integer(sc_status)
      rescue ArgumentError ->
        nil
      end

    cs_bytes =
      try do
        String.to_integer(cs_bytes)
      rescue ArgumentError ->
        nil
      end

    time_taken =
      try do
        String.to_float(time_taken)
      rescue ArgumentError ->
        nil
      end

    %CloudfrontLog{
      timestamp: timestamp,
      edge_location: x_edge_location,
      bytes: sc_bytes,
      client_ip: c_ip,
      method: cs_method,
      host: cs_host,
      path: cs_uri_stem,
      status: sc_status,
      referer: cs_referer,
      user_agent: cs_user_agent,
      query_string: cs_uri_query,
      cookie: cs_cookie,
      cache_hit: x_edge_result_type == "Hit",
      cache_error: x_edge_result_type == "Error",
      request_id: x_edge_request_id,
      host_header: x_host_header,
      https: cs_protocol == "https",
      request_bytes: cs_bytes,
      time_taken: time_taken,
      forwarded_for: x_forwarded_for,
      ssl_protocol: ssl_protocol,
      ssl_cipher: ssl_cipher,
      edge_hit: x_edge_response_result_type == "Hit",
      protocol: cs_protocol_version,
    }
  end
end
