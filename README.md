<div align="center">

# sentiment.nvim

Enhanced matchparen plugin for Neovim to highlight the outer pair.

</div>

## 📹 Demo

**DISCLAIMER**: The autopair functionality is comming from [nvim-autopairs][nvim-autopairs].

[demo.webm](https://user-images.githubusercontent.com/91974155/223225880-2b22dcda-3d38-4a9f-82d5-0e76c0c789e7.webm)

[nvim-autopairs]: https://github.com/windwp/nvim-autopairs

## ✨ Features

-   🚀 Performance (**Blazingly Fast!!!**).

-   🪁 Fully compatible with anything that expects `matchparen.vim` to be there.

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

## 🎮 Usage

-   `:NoMatchParen`

    Disable the plugin.

-   `:DoMatchParen`

    Re-enable the plugin.

## 🚠 Configuration

See [default.lua][default.lua].

[default.lua]: https://github.com/utilyre/sentiment.nvim/blob/main/lua/sentiment/config/default.lua
