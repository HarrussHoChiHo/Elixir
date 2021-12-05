defmodule Sender do
  @moduledoc """
  Documentation for Sender.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Sender.hello()
      :world

  """

<<<<<<< HEAD
  def send_email("konnichiwa@world.com" = email), do:
    raise "Oops, couldn't send email to #{email}!"
=======
  def send_email("konnichiwa@world.com" = _email) do
    :error
  end
>>>>>>> 2c418fe71457ec194b30bd3b392b2b6d4f73073a

  def send_email(email) do
    Process.sleep(3000)
    IO.puts("Email to #{email} sent")
    {:ok, "email_sent"}
  end

  def notify_all(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end

end
