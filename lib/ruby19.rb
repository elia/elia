# A collection of backports from Ruby 1.9 to ruby 1.8

class Object
  def ruby18 &block
    block.call if RUBY_VERSION.to_f == 1.8
  end
end
