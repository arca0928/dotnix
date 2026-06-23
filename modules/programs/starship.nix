{
  delib,
  host,
  ...
}:
delib.module {
  name = "programs.starship";

  options = delib.singleEnableOption host.guiFeatured;

  home.ifEnabled = {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      settings = {
        "$schema" = "https://starship.rs/config-schema.json";

        add_newline = true;
        command_timeout = 1000;
        continuation_prompt = "[∙](240) ";
        format = "$os$directory$git_branch$git_commit$git_status$fill$status$cmd_duration$jobs$direnv$mise$python$conda$nodejs$ruby$lua$java$perl$php$scala$haskell$kubernetes$terraform$aws$azure$gcloud$container$username$hostname$shell$nix_shell$time$line_break$character";
        right_format = "";

        fill = {
          symbol = "─";
          style = "240";
        };

        os = {
          disabled = false;
          format = "[ $symbol ](fg:255 bg:236)";
          symbols = {
            Arch = "";
            Debian = "";
            Linux = "";
            Macos = "";
            NixOS = "";
            Ubuntu = "";
            Windows = "";
          };
        };

        directory = {
          format = "[ $path]($style)[$read_only]($read_only_style) ";
          style = "bold 39 bg:236";
          read_only = "";
          read_only_style = "196 bg:236";
          truncation_length = 1;
          truncate_to_repo = false;
          truncation_symbol = "";
          fish_style_pwd_dir_length = 1;
        };

        git_branch = {
          format = "[ $symbol$branch(:$remote_branch)]($style)";
          symbol = " ";
          style = "76 bg:236";
          truncation_length = 32;
          truncation_symbol = "…";
          ignore_branches = [ ];
          disabled = false;
        };

        git_commit = {
          format = "[ @$hash]($style)";
          style = "76 bg:236";
          only_detached = true;
          tag_disabled = false;
          tag_symbol = "#";
        };

        git_status = {
          format = "([$ahead_behind$stashed$conflicted$staged$modified$untracked$renamed$deleted]($style)) ";
          style = "bg:236";
          ahead = "[ ⇡$count](76 bg:236)";
          behind = "[ ⇣$count](76 bg:236)";
          diverged = "[ ⇣$behind_count⇡$ahead_count](76 bg:236)";
          stashed = "[ *$count](76 bg:236)";
          conflicted = "[ ~$count](196 bg:236)";
          staged = "[ +$count](178 bg:236)";
          modified = "[ !$count](178 bg:236)";
          untracked = "[ ?$count](39 bg:236)";
          renamed = "[ »$count](178 bg:236)";
          deleted = "[ -$count](178 bg:236)";
          disabled = false;
        };

        status = {
          disabled = false;
          format = "[$symbol$status]($style) ";
          success_symbol = "";
          success_style = "70";
          not_executable_symbol = "✘";
          not_found_symbol = "✘";
          sigint_symbol = "✘";
          signal_symbol = "✘";
          symbol = "✘";
          style = "160";
          pipestatus = true;
          pipestatus_format = "[$pipestatus]($style) ";
        };

        cmd_duration = {
          min_time = 3000;
          show_milliseconds = false;
          format = "[took $duration]($style) ";
          style = "248";
        };

        jobs = {
          format = "[$symbol]($style) ";
          symbol = "";
          style = "37";
          number_threshold = 2;
          symbol_threshold = 1;
        };

        direnv = {
          disabled = false;
          format = "[$symbol$loaded/$allowed]($style) ";
          symbol = "󱁿 ";
          style = "178";
        };

        mise = {
          disabled = false;
          format = "[$symbol$health]($style) ";
          symbol = "󰦕 ";
          style = "66";
        };

        python = {
          format = "[$symbol$pyenv_prefix($version )(\\($virtualenv\\) )]($style)";
          style = "37";
          symbol = " ";
          pyenv_version_name = true;
          python_binary = [
            "python3"
            "python"
          ];
        };

        conda = {
          format = "[$symbol$environment]($style) ";
          style = "37";
          symbol = "🅒 ";
          ignore_base = true;
        };

        nodejs = {
          format = "[$symbol($version )]($style)";
          style = "70";
          symbol = " ";
        };

        ruby = {
          format = "[$symbol($version )]($style)";
          style = "168";
          symbol = " ";
        };

        lua = {
          format = "[$symbol($version )]($style)";
          style = "32";
          symbol = " ";
        };

        java = {
          format = "[$symbol($version )]($style)";
          style = "32";
          symbol = " ";
        };

        perl = {
          format = "[$symbol($version )]($style)";
          style = "67";
          symbol = " ";
        };

        php = {
          format = "[$symbol($version )]($style)";
          style = "99";
          symbol = " ";
        };

        scala = {
          format = "[$symbol($version )]($style)";
          style = "160";
          symbol = " ";
        };

        haskell = {
          format = "[$symbol($version )]($style)";
          style = "172";
          symbol = " ";
        };

        kubernetes = {
          disabled = false;
          format = "[$symbol$context( \\($namespace\\))]($style) ";
          style = "134";
          symbol = "󱃾 ";
          detect_extensions = [ ];
          detect_files = [ ];
          detect_folders = [ ];
          detect_env_vars = [
            "KUBECONFIG"
            "KUBERNETES_SERVICE_HOST"
          ];
        };

        terraform = {
          format = "[$symbol$workspace]($style) ";
          style = "38";
          symbol = "󱁢 ";
        };

        aws = {
          format = "[$symbol$profile( $region)]($style) ";
          style = "208";
          symbol = " ";
        };

        azure = {
          disabled = false;
          format = "[$symbol$subscription]($style) ";
          style = "32";
          symbol = "󰠅 ";
        };

        gcloud = {
          format = "[$symbol$project]($style) ";
          style = "32";
          symbol = "󱇶 ";
        };

        container = {
          format = "[$symbol $name]($style) ";
          style = "178";
          symbol = "⬢";
        };

        username = {
          format = "[$user]($style)";
          style_user = "180";
          style_root = "bold 178";
          show_always = false;
        };

        hostname = {
          format = "[@$hostname]($style) ";
          style = "180";
          ssh_only = true;
        };

        shell = {
          disabled = false;
          format = "[$indicator]($style) ";
          style = "178";
          bash_indicator = "bash";
          fish_indicator = "fish";
          zsh_indicator = "";
          nu_indicator = "nu";
          powershell_indicator = "pwsh";
        };

        nix_shell = {
          format = "[$symbol$state( \\($name\\))]($style) ";
          style = "74";
          symbol = " ";
          impure_msg = "impure";
          pure_msg = "pure";
          unknown_msg = "shell";
        };

        time = {
          disabled = false;
          format = "[$time]($style) ";
          style = "66";
          time_format = "%H:%M:%S";
          use_12hr = false;
        };

        character = {
          format = "$symbol ";
          success_symbol = "[❯](76)";
          error_symbol = "[❯](196)";
          vimcmd_symbol = "[❮](76)";
          vimcmd_visual_symbol = "[V](76)";
          vimcmd_replace_symbol = "[▶](76)";
          vimcmd_replace_one_symbol = "[▶](76)";
        };
      };
    };
  };
}
