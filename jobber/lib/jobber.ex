defmodule Jobber do
  @moduledoc """
  Documentation for `Jobber`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Jobber.hello()
      :world

  """
  alias Jobber.{JobRunner, JobSupervisor}

  def start_job(args) do
    if Enum.count(running_imports()) >= 5 do
      {:error, :import_quota_reached}
    end
    DynamicSupervisor.start_child(JobRunner, {JobSupervisor, args})
  end

  def running_imports() do
    match_all = {:"$1", :"$2", :"$3"}
    guards = [{:"==", :"$3", "import"}]
    map_result = [%{id: :"$1", pid: :"$2", type: :"$3"}]
    Registry.select(Jobber.JobRegistry, [{match_all, guards, map_result}])
  end
end

defmodule Jobber.JobSupervisor do
  use Supervisor, restart: :temporary

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  def init(args) do
    children = [{Jobber.Job, args}]

    options = [strategy: :one_for_one, max_seconds: 30]

    Supervisor.init(children, options)
  end
end
