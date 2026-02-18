-- Pandoc Lua filter for Chroma
-- Converts code blocks to HTML using Chroma
-- Requires Chroma in PATH

local pandoc = pandoc
local codeblock_counter = 0

function CodeBlock(block)
  codeblock_counter = codeblock_counter + 1
  local block_id = string.format("codeblk-%02d", codeblock_counter)
  local lang = block.classes[1] or "plaintext"
  local code = block.text

  -- Command: chroma with your options
  local cmd = { "chroma", "--lexer", lang, "--html", "--html-tab-width", 4, "--html-only", "--html-lines", "--html-linkable-lines", "--html-all-styles" }

  -- Call Chroma via stdin/stdout
  local ok, result = pcall(pandoc.pipe, cmd[1], { table.unpack(cmd, 2) }, code)

  if not ok then
    -- Fallback if Chroma fails: return plain <pre><code>
    local escaped = pandoc.utils.stringify(code)
    return pandoc.RawBlock("html", "<pre><code>" .. escaped .. "</code></pre>")
  end

  result = result:gsub('id="L(%d+)"', 'id="' .. block_id .. '-L%1"')
  result = result:gsub('href="#L(%d+)"', 'href="#' .. block_id .. '-L%1"')

  local html_output = string.format("<!-- %s -->\n%s", block_id, result)
  -- Return Chroma output as raw HTML block
  return pandoc.RawBlock("html", html_output)
end
