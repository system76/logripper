defmodule Logripper.Repo.Migrations.CreateCloudfrontLogTable do
  use Ecto.Migration

  def change do
    create table(:cloudfront_log_entries) do
      add :timestamp,     :datetime, null: false                 # date + time
      add :edge_location, :string,   null: false                 # x-edge-location
      add :bytes,         :integer,  null: false                 # sc-bytes
      add :client_ip,     :string,   null: false                 # c-ip
      add :method,        :string,   null: false                 # cs-method
      add :host,          :string,   null: false                 # cs(Host)
      add :path,          :string,   null: false                 # cs-uri-stem
      add :status,        :integer,  null: false                 # sc-status
      add :referer,       :string,   null: false                 # cs(Referer)
      add :user_agent,    :string,   null: false                 # cs(User-Agent)
      add :query_string,  :string,   null: true                  # cs-uri-query
      add :cookie,        :string,   null: true                  # cs(Cookie)
      add :cache_hit,     :boolean,  null: false, default: false # x-edge-result-type (== "Hit")
      add :cache_error,   :boolean,  null: false, default: false # x-edge-result-type (== "Error")
      add :request_id,    :string,   null: false                 # x-edge-request-id
      add :host_header,   :string,   null: false                 # x-host-header
      add :https,         :boolean,  null: false, default: false # cs-protocol
      add :request_bytes, :integer,  null: false                 # cs-bytes
      add :time_taken,    :float,    null: false                 # time-taken
      add :forwarded_for, :string,   null: true                  # x-forwarded-for
      add :ssl_protocol,  :string,   null: true                  # ssl-protocol
      add :ssl_cipher,    :string,   null: true                  # ssl-cipher
      add :edge_hit,      :boolean,  null: false, default: false # x-edge-response-result-type
      add :protocol,      :string,   null: false                 # cs-protocol-version
    end

    create table(:cloudfront_log_files) do
      add :filename, :string, null: false
    end
  end
end
