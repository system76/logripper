# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logripper,
  ecto_repos: [Logripper.Repo]

config :logripper, Logripper.Repo,
  adapter: Ecto.Adapters.MySQL,
  database: "logripper",
  username: "logripper",
  password: "logripper",
  hostname: "localhost"

config :ex_aws,
  region: "us-west-2"

config :logger,
  level: :info
