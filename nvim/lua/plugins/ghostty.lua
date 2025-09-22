-- Ghostty terminal configuration
return {
  {
    -- Provides syntax highlighting for Ghostty config files
    -- Disabled on Linux since Ghostty is primarily macOS-focused
    name = "ghostty",
    dir = "/Applications/Ghostty.app/Contents/Resources/vim/vimfiles/",
    enabled = false,  -- Disabled for Linux compatibility
  },
}
