defmodule Logripper.Repo.Migrations.ChangeBytesToBigint do
  use Ecto.Migration

  def change do
    alter table(:cloudfront_log_entries) do
      modify :bytes, :bigint
    end
  end
end
