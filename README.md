<div align="center">

# sentiment.nvim

Enhanced matchparen plugin for Neovim to highlight the outer pair.

</div>

## ✨ Features

-   🚀 Performance (**Blazingly Fast!!!**).

-   👍 Ease of use.

## 📦 Installation

**NOTE**: Keep in mind that calling `setup` disables the built-in
[matchparen.vim][matchparen.vim] plugin.

-   [lazy.nvim][lazy.nvim]

    ```lua
    {
      "utilyre/sentiment.nvim",
      name = "sentiment",
      version = "*",
      opts = {
        -- config
      },
    }
    ```

-   [packer.nvim][packer.nvim]

    ```lua
    {
      "utilyre/sentiment.nvim",
      tag = "*",
      config = function()
        require("sentiment").setup({
          -- config
        })
      end,
    }
    ```

[matchparen.vim]: https://github.com/neovim/neovim/blob/master/runtime/plugin/matchparen.vim
[lazy.nvim]: https://github.com/folke/lazy.nvim
[packer.nvim]: https://github.com/wbthomason/packer.nvim

## 🚠 Configuration

See [default.lua][default.lua].

[default.lua]: https://github.com/utilyre/sentiment.nvim/blob/main/lua/sentiment/config/default.lua
