module PathOperator
  def / *others
    File.join self, *others.map(&:to_s)
  end
  
  def to_path
    Pathname.new(self.to_s)
  end
end

String.class_eval{include PathOperator}
Symbol.class_eval{include PathOperator}


class Pathname
  def / *others
    join *others.map(&:to_s)
  end
  
  def from other_path
    self.relative_path_from( other_path.to_path )
  end
  
  def absolute
    "/#{self}".to_path
  end
  
  def to_path
    self
  end
end
