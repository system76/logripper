defmodule Logripper.CloudfrontLog do
  use Ecto.Schema

  schema "cloudfront_log_entries" do
    field :timestamp,     :naive_datetime # date + time
    field :edge_location, :string         # x-edge-location
    field :bytes,         :integer        # sc-bytes
    field :client_ip,     :string         # c-ip
    field :method,        :string         # cs-method
    field :host,          :string         # cs(Host)
    field :path,          :string         # cs-uri-stem
    field :status,        :integer        # sc-status
    field :referer,       :string         # cs(Referer)
    field :user_agent,    :string         # cs(User-Agent)
    field :query_string,  :string         # cs-uri-query
    field :cookie,        :string         # cs(Cookie)
    field :cache_hit,     :boolean        # x-edge-result-type (== "Hit")
    field :cache_error,   :boolean        # x-edge-result-type (== "Error")
    field :request_id,    :string         # x-edge-request-id
    field :host_header,   :string         # x-host-header
    field :https,         :boolean        # cs-protocol
    field :request_bytes, :integer        # cs-bytes
    field :time_taken,    :float          # time-taken
    field :forwarded_for, :string         # x-forwarded-for
    field :ssl_protocol,  :string         # ssl-protocol
    field :ssl_cipher,    :string         # ssl-cipher
    field :edge_hit,      :boolean        # x-edge-response-result-type
    field :protocol,      :string         # cs-protocol-version
  end
end
