function str = naca_to_str(n)
  if n < 100
    str = sprintf('00%d', n);
  elseif n < 1000
    str = sprintf('0%d', n);
  else
    str = sprintf('%d', n);
  end
end
