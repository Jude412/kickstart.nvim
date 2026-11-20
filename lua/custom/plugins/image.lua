-- Image preview via Sixel graphics (Konsole supports Sixel natively; it only
-- implements the "direct" transmission mode of the Kitty graphics protocol,
-- which imgpreview.nvim and image.nvim's kitty backend don't use locally,
-- so Sixel is the reliable path here). Requires ImageMagick built with sixel
-- support (`magick -list format | grep -i sixel`), which is already present.
vim.pack.add { 'https://github.com/3rd/image.nvim' }

---@diagnostic disable-next-line: missing-fields
require('image').setup {
    backend = 'sixel',
    processor = 'magick_cli',
    -- Render .png/.jpg/etc buffers as images instead of raw bytes, e.g. when
    -- opened from nvim-tree with <CR>.
    hijack_file_patterns = { '*.png', '*.jpg', '*.jpeg', '*.gif', '*.webp', '*.avif' },
    max_width_window_percentage = 90,
    max_height_window_percentage = 80,
}
