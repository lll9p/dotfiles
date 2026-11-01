<directive name="tool_selection">
  <trigger>Before any tool call that reads a file, searches text, or lists a directory</trigger>
  <action>
    Prefer the dedicated tool over `bash` whenever one fits: `read` for file contents, `grep` for text search, `find` for filename patterns, `ls` for directory listings.
    Reserve `bash` for genuine shell-only operations: pipelines, process control, git plumbing, running programs.
    The dedicated tools cap long lines at 500 characters, respect .gitignore, and return structured results. Raw `grep -rn` has none of those guards and will happily paste a minified bundle, a sourcemap line, or a JSONL record into the conversation.
 </action>
</directive>
