<directive name="tool_selection">
  <trigger>Before any tool call that reads a file, searches text, or lists a directory</trigger>
  <action>
    Prefer the dedicated tool over `bash` whenever one fits: `read` for file contents, `grep` for text search, `find` for filename patterns, `ls` for directory listings.
    Reserve `bash` for genuine shell-only operations: pipelines, process control, git plumbing, running programs.
    The dedicated tools cap long lines at 500 characters, respect .gitignore, and return structured results. Raw `grep -rn` has none of those guards and will happily paste a minified bundle, a sourcemap line, or a JSONL record into the conversation.
 </action>
</directive>

<directive name="batch_tool_calls">
    <trigger>Whenever you issue a tool call and further calls are foreseeable</trigger>
    <action>
      Maximize parallel tool calls. Put every independent call in the SAME block.
      Call sequentially only when a later call needs a value from an earlier result.
      For `bash`, prefer one compound command with `;` separators over several calls.
      Every round re-reads the entire conversation, so a round costs real money that grows as the session grows.
      Splitting calls that could have shared a round is the most expensive habit available to you, and it gets worse the longer the session runs.
    </action>
</directive>
