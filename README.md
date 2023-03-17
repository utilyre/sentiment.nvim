<div align="center">

# sentiment.nvim

Enhanced [matchparen.vim][matchparen.vim] plugin for Neovim to highlight the
outer pair.

[matchparen.vim]: https://github.com/neovim/neovim/blob/master/runtime/plugin/matchparen.vim

</div>

## 📹 Demo

**DISCLAIMER**: The autopair functionality is coming from
[nvim-autopairs][nvim-autopairs].

[demo.webm](https://user-images.githubusercontent.com/91974155/223225880-2b22dcda-3d38-4a9f-82d5-0e76c0c789e7.webm)

[nvim-autopairs]: https://github.com/windwp/nvim-autopairs

## ✨ Features

-   🚀 Performance (**Blazingly Fast!!!**).

-   🪁 Fully compatible with anything that expects
    [matchparen.vim][matchparen.vim] to be there.

-   👍 Ease of use.

[matchparen.vim]: https://github.com/neovim/neovim/blob/master/runtime/plugin/matchparen.vim

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

-   `require("sentiment").disable()`, `:NoMatchParen`

    Disable the plugin.

-   `require("sentiment").enable()`, `:DoMatchParen`

    Re-enable the plugin.

## 🚠 Configuration

<details>

<summary>Click to see the default config</summary>

```lua
{
  ---Dictionary to check whether a buftype should be included.
  ---
  ---@type table<string, boolean>
  included_buftypes = {
    [""] = true,
  },

  ---Dictionary to check whether a filetype should be excluded.
  ---
  ---@type table<string, boolean>
  excluded_filetypes = {},

  ---Dictionary to check whether a mode should be included.
  ---
  ---@type table<string, boolean>
  included_modes = {
    n = true,
    i = true,
  },

  ---How much (in milliseconds) should the cursor stay still to calculate and
  ---render a pair.
  ---
  ---NOTE: It's recommended to set this somewhere above and close to your key
  ---repeat speed in order to keep the calculations at minimum.
  ---
  ---@type integer
  delay = 50,

  ---How many lines to look backwards/forwards to find a pair.
  ---
  ---@type integer
  limit = 100,

  ---List of `(left, right)` pairs.
  ---
  ---@type tuple<string, string>[]
  pairs = {
    { "(", ")" },
    { "{", "}" },
    { "[", "]" },
  },
}
```

</details>
