module StringNibbles
  def nibbles width = nil
    s = self.unpack('H*').first.scan(/(..)/).flatten
    if width
      s.in_groups_of(width).map { |group| group.join(' ') }
    else
      s.join(' ')
    end
  end
end

String.send :include, StringNibbles
