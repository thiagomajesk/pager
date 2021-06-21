ExUnit.start()

defmodule Pager.Repo do
  use Ecto.Repo,
    otp_app: :pager,
    adapter: Ecto.Adapters.Postgres

  use Pager
end

Application.put_env(
  :pager,
  Pager.Repo,
  url: "ecto://postgres:postgres@localhost/pager_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  log: false
)

defmodule Pager.User do
  use Ecto.Schema

  schema "users" do
    field(:name, :string)
    timestamps()
  end
end

_ = Ecto.Adapters.Postgres.storage_down(Pager.Repo.config())

:ok = Ecto.Adapters.Postgres.storage_up(Pager.Repo.config())

{:ok, _pid} = Pager.Repo.start_link()

Code.require_file("setup_migration.exs", __DIR__)

:ok = Ecto.Migrator.up(Pager.Repo, 0, Pager.SetupMigration, log: false)

Ecto.Adapters.SQL.Sandbox.mode(Pager.Repo, {:shared, self()})
