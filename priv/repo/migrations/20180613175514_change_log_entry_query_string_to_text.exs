defmodule Logripper.Repo.Migrations.ChangeLogEntryQueryStringToText do
  use Ecto.Migration

  def change do
    alter table(:cloudfront_log_entries) do
      modify :query_string, :text
    end
  end
end
