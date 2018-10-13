use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :whisp, WhispWeb.Endpoint,
  secret_key_base: "zasVblc3Jsjq/XQHV4pTPTj30L8L4/EbZz1okyP6m64lmx7Yk5V2s18r36zU2RFX"

# Configure your database
config :whisp, Whisp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "whisp_prod",
  pool_size: 15
