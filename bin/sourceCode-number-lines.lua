function CodeBlock(el)
  for _, cls in ipairs(el.classes) do
    if cls == "number-lines" then
      return el
    end
  end

  table.insert(el.classes, "number-lines")
  return el
end
