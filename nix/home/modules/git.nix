inputs:
{
  # Start with a simple git configuration (email configured manually per system)
  programs.git = {
    enable = true;
    settings.user.name = "Eric Groom";
  };
}
