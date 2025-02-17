return function(is_math)
  is_math = is_math or function()
    return true
  end
  local ls = require("luasnip")
  local sn = ls.snippet_node
  local i = ls.insert_node
  local f = ls.function_node

  -- snippet but with default wordTrig = false and trigEngine = "plain"
  local function snippet(context, nodes, opts)
    context = type(context) == "table" and context or { trig = context }
    context.wordTrig = context.wordTrig == true
    context.trigEngine = context.trigEngine or "plain"
    return ls.snippet(context, nodes, opts)
  end

  -- snippet that expands only in mathmode, default wordTrig = false and trigEngine = "plain"
  local function math_snippet(context, nodes, opts)
    opts = opts or {}
    local raw_cond = opts.condition or function()
      return true
    end
    opts.condition = function(...)
      return raw_cond(...) and is_math() == 1
    end
    return snippet(context, nodes, opts)
  end

  -- snippet that expands only outside of mathmode, default wordTrig = false and trigEngine = "plain"
  local function text_snippet(context, nodes, opts)
    opts = opts or {}
    local raw_cond = opts.condition or function()
      return true
    end
    opts.condition = function(...)
      return raw_cond(...) and is_math() == 0
    end
    return snippet(context, nodes, opts)
  end

  -- match lua patterns, return matched and captures
  local function match_single(line_to_cursor, trigger)
    -- look for match which ends at the cursor,
    -- put all results into a list, there might be many capture-groups
    local find_res = { line_to_cursor:find(trigger .. "$") }

    if #find_res > 0 then
      -- if there is a match, determine matching string and the capture-groups
      local captures = {}
      -- find_res[1] is `from`, find_res[2] is `to` (which we already know)
      local from = find_res[1]
      local match = line_to_cursor:sub(from, #line_to_cursor)
      -- collect capture-groups
      for k = 3, #find_res do
        captures[k - 2] = find_res[k]
      end
      return match, captures
    else
      return nil
    end
  end

  -- match multiple patterns, choose the longest match
  local function match_multi(line_to_cursor, triggers)
    triggers = type(triggers) == "table" and triggers or { triggers }
    local has_match = false
    local match = ""
    local captures = {}
    for _, trig in ipairs(triggers) do
      local results = { match_single(line_to_cursor, trig) }
      if #results > 0 and #results[1] > #match then
        match = results[1]
        captures = results[2]
        has_match = true
      end
    end

    if has_match then
      return match, captures
    else
      return nil
    end
  end

  -- postfix for latext command
  -- Usage: \command1<trig> -> \<cmd>{\command1}
  -- By default only expand in math mode
  local postfix_command = function(trig, args)
    local patterns = args.patterns or { "\\[%w]+%{[^%}%s]*[^%{%s]*%}", "\\[%w]+", "%s?([%w])" }
    local resolve_expand_params = function(_, line_to_cursor, match, _)
      local line_to_cursor_except_match = line_to_cursor:sub(1, #line_to_cursor - #match)
      local postfix_match, captures = match_multi(line_to_cursor_except_match, patterns)
      -- print(postfix_match)

      if postfix_match == nil then
        return nil
      end

      local pos = require("luasnip.util.util").get_cursor_0ind()
      local res = {
        clear_region = {
          from = { pos[1], pos[2] - #postfix_match - #match },
          to = pos,
        },
        env_override = {
          POSTFIX_MATCH = postfix_match,
          POSTFIX_CAPTURES = captures,
        },
      }
      return res
    end

    local context = { trig = trig, resolveExpandParams = resolve_expand_params }
    args = args or {}
    args.mathmode = args.mathmode == nil and true or args.mathmode
    local opts = {
      condition = function()
        return not args.mathmode or is_math() == 1
      end,
    }
    local nodes = args.nodes
      or {
        f(function(_, parent)
          local match = parent.snippet.env.POSTFIX_MATCH
          local captures = parent.snippet.env.POSTFIX_CAPTURES
          local content = #captures > 0 and captures[1] or match
          return "\\" .. args.cmd .. "{" .. content .. "}"
        end),
      }

    return snippet(context, nodes, opts)
  end

  -- When `LS_SELECT_RAW` is populated with a visual selection, the function returns
  --  an insert node whose initial text is set to the visual selection.
  -- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert node
  local function get_visual(_, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
      return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else
      return sn(nil, i(1))
    end
  end

  -- Regex captures in lua patterns
  local function get_match(index)
    return function(_, parent)
      return parent.captures[index]
    end
  end

  return {
    snippet = snippet,
    math_snippet = math_snippet,
    text_snippet = text_snippet,
    postfix_command = postfix_command,
    get_visual = get_visual,
    get_match = get_match,
  }
end
