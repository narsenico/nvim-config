# neovim config

## Combinazione tasti con Meta

La combinazione dei tasti con Meta `<M->` non funziona sul mac sostituirla con Command `<D->`.

Ad esempio in `mini.pick`

```lua
require('mini.pick').setup({
	mappings = {
		-- choose_marked     = '<M-CR>', NOT WORKING ON MAC
		choose_marked = '<D-CR>', -- cmd+enter on mac
	}
```
