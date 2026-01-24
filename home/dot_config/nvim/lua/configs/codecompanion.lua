vim.cmd [[cab cc CodeCompanion]]
vim.cmd [[cab ccc CodeCompanionChat]]
vim.cmd [[cab cca CodeCompanionActions]]

local UNIFY_ENDPOINT = vim.env["AI_BASE_URL"]
local UNIFY_APIKEY = vim.env["AI_BASE_TOKEN"]

if not UNIFY_ENDPOINT or not UNIFY_APIKEY then
   vim.notify("CodeCompanion: AI_BASE_URL or AI_BASE_TOKEN environment variable not set", vim.log.levels.WARN)
end

-- default adapters
local model = { name = "newapi", model = "gemini-3-pro-preview" }
local inline_model = { name = "newapi", model = "gemini-3-flash-preview-short" }
local agent_model = { name = "newapi", model = "gemini-3-flash-preview-short" }
local cmd_model = { name = "newapi", model = "gemini-3-flash-preview-short" }
local background_model = { name = "newapi", model = "gemini-3-flash-preview-short" }
local quick_model = { name = "newapi", model = "gemini-flash-lite-latest" }

local unify_choices = {
   ["gemini-3-pro-preview"] = { formatted_name = "Gemini 3 Pro", opts = { can_reason = true, has_vision = true } },
   ["gemini-3-flash-preview"] = { formatted_name = "Gemini 3 Flash", opts = { can_reason = true, has_vision = true } },
   ["gemini-3-flash-preview-short"] = {
      formatted_name = "Gemini 3 Flash Short",
      opts = { can_reason = true, has_vision = true },
   },
   ["z-ai/glm4.7"] = { formatted_name = "Glm-4.7", opts = { can_reason = true, has_vision = false } },
   ["minimaxai/minimax-m2.1"] = { formatted_name = "Minimax-M2.1", opts = { can_reason = true, has_vision = false } },
}

-- Map non-standard provider fields (thinking/reasoning) into CodeCompanion's
-- expected `output.reasoning` shape so `display.chat.show_reasoning` works.
---@param data {status: string, output: table, extra: table}|nil
---@return {status: string, output: table, extra: table}|nil
local function parse_reasoning_from_extra(data)
   if not data or type(data) ~= "table" then
      return data
   end
   data.output = data.output or {}
   local extra = data.extra
   if not extra or type(extra) ~= "table" then
      return data
   end

   local reasoning = nil

   -- Common fields used by OpenAI-compatible proxies/providers
   if type(extra.reasoning_content) == "string" and extra.reasoning_content ~= "" then
      reasoning = { content = extra.reasoning_content }
   elseif type(extra.thinking) == "string" and extra.thinking ~= "" then
      reasoning = { content = extra.thinking }
   elseif type(extra.thoughts) == "string" and extra.thoughts ~= "" then
      reasoning = { content = extra.thoughts }
   elseif type(extra.reasoning) == "string" and extra.reasoning ~= "" then
      reasoning = { content = extra.reasoning }
   elseif type(extra.reasoning) == "table" then
      -- Some providers return `{ reasoning = { content = "..." } }`
      if type(extra.reasoning.content) == "string" and extra.reasoning.content ~= "" then
         reasoning = extra.reasoning
      end
   elseif type(extra.analysis) == "string" and extra.analysis ~= "" then
      -- Last-resort fallback used by some proxies
      reasoning = { content = extra.analysis }
   end

   if reasoning then
      data.output.reasoning = reasoning
      -- When streaming, many providers emit reasoning chunks with `content == ""`.
      -- If we let an empty LLM message through, the UI will treat it as a
      -- reasoning->response transition and restart the reasoning block on every
      -- chunk, creating many tiny "Reasoning" sections/folds.
      if data.output.content == "" then
         data.output.content = nil
      end
   end

   return data
end

local rules = {
   {
      condition = function(context)
         return context.filetype == "typescript" or context.filetype == "typescriptreact"
      end,
      content = [[
You are a strict TypeScript developer. Follow these rules:
- Use functional programming patterns where possible.
- Prefer interfaces over types for public APIs.
- Ensure all functions have explicit return types.
- Avoid 'any' at all costs; use 'unknown' if necessary.
]],
   },
   {
      condition = function(context)
         return context.filetype == "lua"
      end,
      content = [[
You are an expert Neovim plugin developer.
- Use 'vim.api' and 'vim.fn' correctly.
- Prefer 'snacks' or 'mini' libraries when appropriate.
- Follow Lua best practices in Neovim (e.g., local variables, module structure).
]],
   },
}

local options = {
   interactions = {
      chat = {
         roles = {
            system = {
               opts = {
                  rules = rules,
               },
            },
         },
         adapter = model,
         tools = {
            opts = {
               auto_submit_errors = true,
               auto_submit_success = true,
            },
            ["buffer"] = {
               opts = {
                  default_params = "diff",
               },
            },
            ["cmd_runner"] = {
               opts = {
                  provider = "snacks",
                  requires_approval_before = true,
               },
            },
         },
      },
      inline = { adapter = inline_model },
      agent = { adapter = agent_model },
      cmd = { adapter = cmd_model },
      background = { adapter = background_model },
   },
   adapters = {
      acp = {
         opencode = "opencode",
      },
      http = {
         opts = {
            show_model_choices = true,
            show_presets = true,
         },
         newapi = function()
            local adapter = require("codecompanion.adapters").extend("openai_compatible", {
               name = "newapi",
               formatted_name = "New API",
               env = {
                  api_key = UNIFY_APIKEY,
                  url = UNIFY_ENDPOINT,
               },
               schema = {
                  model = {
                     default = "gemini-3-flash-preview-short",
                     choices = unify_choices,
                  },
                  temperature = { default = 0.3 },
                  reasoning_effort = { default = "high" },
               },
            })

            adapter.handlers = adapter.handlers or {}
            adapter.handlers.parse_message_meta = function(_, data)
               return parse_reasoning_from_extra(data)
            end

            return adapter
         end,
         newapi = function()
            local adapter = require("codecompanion.adapters").extend("openai_compatible", {
               name = "newapi",
               formatted_name = "New API",
               env = {
                  api_key = UNIFY_APIKEY,
                  url = UNIFY_ENDPOINT,
               },
               schema = {
                  model = {
                     default = "gemini-3-flash-preview-short",
                     choices = unify_choices,
                  },
                  temperature = { default = 0.3 },
                  reasoning_effort = { default = "high" },
               },
            })

            adapter.handlers = adapter.handlers or {}
            adapter.handlers.parse_message_meta = function(_, data)
               return parse_reasoning_from_extra(data)
            end

            return adapter
         end,
      },
   },
   display = {
      action_palette = {
         provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
         show_preset_prompts = false,
      },
      chat = {
         intro_message = "✨CodeCompanion✨ ? for Opts",
         opts = {
            completion_provider = "blink", -- blink|cmp|coc|default
         },
         auto_scroll = true,
         show_header_separator = true,
         show_settings = false,
         start_in_insert_mode = false,
         fold_reasoning = true,
         show_reasoning = true,
         show_tools_processing = true, -- Show the loading message when tools are being executed?
         show_token_count = true, -- Show the token count for each response?
      },
      diff = {
         enabled = true,
         provider = "mini.diff",
      },
   },

   prompt_library = {
      ["Document"] = {
         interaction = "chat",
         description = "Document visual block of code",
         opts = {
            alias = "Document",
            mapping = "<LocalLeader>aD",
            modes = { "v" },
            auto_submit = true,
            stop_context_insertion = false,
            is_slash_cmd = true,
         },
         prompts = {
            {
               role = "system",
               content = function(context)
                  return "You are an experienced "
                     .. context.filetype
                     .. " engineer. You have experience on writing documentation and will be asked to write documentation."
               end,
            },
            {
               role = "user",
               content = function(context)
                  local visual = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "@{insert_edit_into_file} write documentation for the following code in the #{buffer} , do not include an example:\n\n```"
                     .. context.filetype
                     .. "\n"
                     .. visual
                     .. "\n```\n"
               end,
               opts = {
                  contains_code = true,
               },
            },
         },
      },
      ["Explain"] = {
         interaction = "chat",
         description = "Explain the code in the file type",
         opts = {
            alias = "Explain",
            mapping = "<LocalLeader>aE",
            modes = { "v" },
            auto_submit = false,
            stop_context_insertion = true,
            is_slash_cmd = true,
         },
         prompts = {
            {
               role = "system",
               content = function(context)
                  return "You are an experienced "
                     .. context.filetype
                     .. " engineer. I will ask you specific question and I want you to return concise explanations, codeblock examples, and excerpts from source documentation."
               end,
            },
            {
               role = "user",
               content = function(context)
                  local visual = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "I have the following code:\n\n```" .. context.filetype .. "\n" .. visual .. "\n```\n\n"
               end,
               opts = {
                  contains_code = true,
               },
            },
         },
      },
   },
   opts = {
      log_level = "ERROR", -- INFO/ERROR/TRACE
      language = "Chinese",
   },
}

return options
