unless is_pid(Process.whereis(:exunit_server)), do: ExUnit.start
