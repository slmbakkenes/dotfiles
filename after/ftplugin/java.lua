-- Java editor settings
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Run current Java file (compile + run)
vim.keymap.set("n", "<leader>crj", function()
	local file = vim.fn.expand("%:p")
	local dir = vim.fn.expand("%:p:h")
	local name = vim.fn.expand("%:t:r")
	vim.cmd("split | terminal cd " .. dir .. " && javac " .. file .. " && java -cp " .. dir .. " " .. name)
end, { buffer = 0, silent = true, desc = "Run Java file" })

-- Run Spring Boot app (auto-detects mvnw/gradlew)
vim.keymap.set("n", "<leader>crb", function()
	local root = vim.fs.root(0, { "pom.xml", "build.gradle", "build.gradle.kts" })
	if not root then
		vim.notify("No pom.xml or build.gradle found", vim.log.levels.WARN)
		return
	end

	local cmd
	if vim.uv.fs_stat(root .. "/mvnw") then
		cmd = "./mvnw spring-boot:run"
	elseif vim.uv.fs_stat(root .. "/gradlew") then
		cmd = "./gradlew bootRun"
	elseif vim.uv.fs_stat(root .. "/pom.xml") then
		cmd = "mvn spring-boot:run"
	else
		cmd = "gradle bootRun"
	end

	vim.cmd("split | terminal cd " .. vim.fn.fnameescape(root) .. " && " .. cmd)
end, { buffer = 0, silent = true, desc = "Run Spring Boot app" })
