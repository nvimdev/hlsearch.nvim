# hlsearch.nvim
auto remove search highlight and rehighlight when using n or N

## Install

- with packer.nvim

```lua
packer.use {'nvimdev/hlsearch.nvim', event = 'BufRead' config = function()
    require('hlsearch').setup()
end}
```

## Showcase

![images](https://user-images.githubusercontent.com/41671631/202900349-8129cd13-6068-4c07-8e94-9f0cfd15e2df.gif)

## License MIT
