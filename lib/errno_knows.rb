module ErrnoKnows
  def knows? error
    @constants ||= constants.map{|n| const_get(n)}
    @constants.include? error.class
  end
end

module Errno
  extend ErrnoKnows
end

