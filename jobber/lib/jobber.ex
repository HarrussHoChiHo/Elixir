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
    DynamicSupervisor.start_child(JobRunner, {JobSupervisor, args})
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
