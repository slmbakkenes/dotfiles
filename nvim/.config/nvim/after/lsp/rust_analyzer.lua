-- Resolve the binary explicitly instead of trusting PATH order. Version-manager
-- shims (mise, asdf) can shadow rustup's proxy; when the active toolchain lacks
-- the rust-analyzer component, rustup's own PATH fallback bounces straight back
-- into that shim and the server dies with "infinite recursion detected".
--
-- The rustup *proxy* is pinned rather than a toolchain-resolved binary, so a
-- project's rust-toolchain.toml still decides which rust-analyzer actually runs.
local function resolve_cmd()
	local cargo_home = os.getenv("CARGO_HOME") or (vim.uv.os_homedir() .. "/.cargo")
	local proxy = cargo_home .. "/bin/rust-analyzer"
	if vim.fn.executable(proxy) == 1 then
		return { proxy }
	end

	-- No rustup (e.g. distro-packaged rust-analyzer); nil leaves nvim-lspconfig's
	-- default cmd in place so a missing binary reports the usual error.
	local exe = vim.fn.exepath("rust-analyzer")
	return exe ~= "" and { exe } or nil
end

-- Run clippy instead of `cargo check` on save: strictly more lints for the same
-- compile cost. Deep-merged over nvim-lspconfig's definition, so its codelens
-- settings survive.
return {
	cmd = resolve_cmd(),
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
}
