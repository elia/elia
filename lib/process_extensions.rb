module ProcessExtensions
  def exist?(pid)
    kill(0, pid) rescue false
  end
  alias exists? exist?
  
  def kill!(pid)
    kill('KILL', pid)
  end
end

Process.extend ProcessExtensions
