local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt,
  b.formatting.prettier,

  -- diagnostics
  b.diagnostics.write_good,
  b.diagnostics.open_float,
  -- b.diagnostics.markdownlint,
  b.diagnostics.eslint_d,
  b.diagnostics.flake8,
  b.diagnostics.tsc,

  -- Lua
  b.formatting.stylua,

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
}

null_ls.setup {
  debug = true,
  sources = sources,
}
