defmodule Logripper.Repo.Migrations.ChangeUserAgentToText do
  use Ecto.Migration

  def change do
    alter table(:cloudfront_log_entries) do
      modify :user_agent, :text
      modify :referer, :text
      modify :path, :text
    end
  end
end
