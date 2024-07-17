lsp:
let
  outputs = {
    elixir-ls = ''
      # VS Code language server configuration
      export ELS_INSTALL_PREFIX="${lsp}/lib"

      # VS Code extension crash workaround
      export ELS_MODE=language_server
      export ELS_SCRIPT="ElixirLS.LanguageServer.CLI.main()"

      # Emacs
      export PATH="$ELS_INSTALL_PREFIX:$PATH"
    '';
  };
in
outputs.${lsp.pname or ""} or ""
