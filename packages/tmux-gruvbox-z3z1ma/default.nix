{
  tmuxPlugins,
  fetchFromGitHub,
}:

tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-gruvbox-z3z1ma";
  rtpFilePath = "gruvbox.tmux";
  version = "2024-10-26";
  src = fetchFromGitHub {
    owner = "z3z1ma";
    repo = "tmux-gruvbox";
    rev = "8f71abd479e60f9a663abdc42e06491b7e8e6a25";
    sha256 = "c0184e28cf3968e715e230fbc1dc81ff35ca0dd84e0c4e64d62b9df9c9ba5a4d";
  };
}
