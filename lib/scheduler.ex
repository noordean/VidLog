defmodule VidLog.Scheduler do
    use GenServer

    def init(state) do
      handle_info("no message to send", state)
      {:ok, state}
    end

    def start_link(_) do
      GenServer.start_link(__MODULE__, %{})
    end

    def handle_info(_msg, state) do
      VidLog.run()
      Process.send_after(self(), "no message to send", 1 * 60 * 1000)
      {:noreply, state}
    end
  end
