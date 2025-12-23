vim.cmd [[cab cc CodeCompanion]]
vim.cmd [[cab ccc CodeCompanionChat]]
vim.cmd [[cab cca CodeCompanionActions]]

local UNIFY_ENDPOINT = vim.env["AI_BASE_URL"]
local UNIFY_APIKEY = vim.env["AI_BASE_TOKEN"]

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

local options = {
   interactions = {
      chat = {
         adapter = "gemini",
         model = "gemini-3-flash-preview",
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
      inline = { adapter = "gemini", model = "gemini-3-flash-preview" },
      agent = { adapter = "gemini", model = "gemini-3-flash-preview" },
      cmd = { adapter = "gemini", model = "gemini-3-flash-preview" },

      background = {
         adapter = "newapi",
         chat = {
            model = "gemini-2.5-flash-lite",
            opts = { enabled = true },
         },
      },
   },
   adapters = {
      acp = {
         opencode = "opencode",
      },
      http = {
         newapi = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
               name = "new_api",
               formatted_name = "New-API",
               env = {
                  api_key = UNIFY_APIKEY,
                  url = UNIFY_ENDPOINT,
               },
               handlers = {
                  parse_message_meta = function(self, data)
                     return parse_reasoning_from_extra(data)
                  end,
               },
               schema = {
                  model = {
                     default = "deepseek-ai/DeepSeek-V3.2-thinking",
                     choices = {
                        ["deepseek-ai/DeepSeek-V3.2-thinking"] = {
                           opts = {
                              can_use_tools = true,
                              has_vision = false,
                              can_reason = true,
                              stream = true,
                           },
                        },
                     },
                  },
               },
            })
         end,
         gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
               url = UNIFY_ENDPOINT .. "/v1/chat/completions",
               env = {
                  api_key = UNIFY_APIKEY,
               },
               handlers = {
                  parse_message_meta = function(self, data)
                     return parse_reasoning_from_extra(data)
                  end,
               },
            })
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
