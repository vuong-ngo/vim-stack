-- ================================================
--   _   ____  ______  _  _______  _  ___________ 
--  | | / / / / / __ \/ |/ / ___/ / |/ / ___/ __ \
--  | |/ / /_/ / /_/ /    / (_ / /    / (_ / /_/ /
--  |___/\____/\____/_/|_/\___/ /_/|_/\___/\____/ 
-- ================================================

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- NOTE: plugins under lua/plugins/*.lua are NOT required manually here.
-- config/lazy.lua already registers `{ import = "plugins" }` as a lazy.nvim
-- spec, which auto-discovers and loads every file in that folder. Requiring
-- them again here was dead weight (each spec table would just get loaded
-- into the module cache a second time with no effect) and has been removed.
