{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      # General settings
      add_newline = false;

      # Customize the look of the prompt character
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      # Only display username when not root
      username = {
        disabled = false;
        show_always = false;
        style_user = "bold green";
        style_root = "bold red";
      };

      # Only display hostname for remote sessions
      hostname = {
        disabled = false;
        ssh_only = true;
        style = "bold yellow";
      };

      # Show directory with truncation for deep paths
      directory = {
        truncation_length = 2;
        truncation_symbol = "…/";
        format = "[$path]($style) ";
        style = "cyan bold";
      };

      # Git branch and commit information
      git_branch = {
        format = "[$branch]($style)";
        style = "bold purple";
        disabled = false;
      };

      git_commit = {
        disabled = false;
        style = "bold yellow";
        format = "($hash)";
      };

      git_state = {
        format = "[$state]($style)";
        style = "bold yellow";
      };

      git_status = {
        format = "[$all_status]($style) ";
        style = "bold red";
      };

      # Python virtual environment info
      python = {
        format = "🐍 [$virtualenv]($style) ";
        disabled = false;
        style = "yellow bold";
      };

      # Node.js version display
      nodejs = {
        format = "⬢ [$version]($style)";
        disabled = false;
        style = "green bold";
      };

      # Show package version if inside a project
      package = {
        format = "[📦 $version]($style)";
        disabled = false;
        style = "bold blue";
      };

      # Show command duration if it exceeds 2 seconds
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };

      # Show active background jobs
      jobs = {
        format = "[$symbol$number]($style) ";
        style = "bold blue";
      };
    };
  };
}
