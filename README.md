<div align="center">

# sentiment.nvim

Enhanced matchparen plugin for Neovim to highlight the outer pair.

</div>

## ✨ Features

-   🚀 Performant (**Blazingly Fast!!!**).

-   👍 Ease of use.

## 📦 Installation

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

[lazy.nvim]: https://github.com/folke/lazy.nvim
[packer.nvim]: https://github.com/wbthomason/packer.nvim

## 🚠 Configuration

See [default.lua][default.lua].

[default.lua]: https://github.com/utilyre/sentiment.nvim/blob/main/lua/sentiment/config/default.lua
