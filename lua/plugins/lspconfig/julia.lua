return {
  julials = function(use_mason)
    return {
      mason = use_mason,
      cmd = {
        "julia",
        "--startup-file=no",
        "--history-file=no",
        "--project=~/.config/nvim/julials_env/",
        "-e",
        " "
          .. "    using LanguageServer\n"
          .. "    using SymbolServer\n"
          .. '    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")\n'
          .. "    project_path = let\n"
          .. "        dirname(something(\n"
          .. "            ## 1. Finds an explicitly set project (JULIA_PROJECT)\n"
          .. "            Base.load_path_expand((\n"
          .. '                p = get(ENV, "JULIA_PROJECT", nothing);\n'
          .. "                p === nothing ? nothing : isempty(p) ? nothing : p\n"
          .. "            )),\n"
          .. "            ## 2. Look for a Project.toml file in the current working directory,\n"
          .. "            ##    or parent directories, with $HOME as an upper boundary\n"
          .. "            Base.current_project(),\n"
          .. "            ## 3. First entry in the load path\n"
          .. "            get(Base.load_path(), 1, nothing),\n"
          .. "            ## 4. Fallback to default global environment,\n"
          .. "            ##    this is more or less unreachable\n"
          .. '            Base.load_path_expand("@v#.#"),\n'
          .. "        ))\n"
          .. "    end\n"
          .. '    @info "Running language server" VERSION pwd() project_path depot_path\n'
          .. "    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)\n"
          .. "    server.runlinter = true\n"
          .. "    run(server)\n"
          .. "  ",
      },
    }
  end,
}
