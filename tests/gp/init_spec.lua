local assert = require("luassert")
local gp = require("gp")

describe("gp.nvim", function()
  before_each(function()
    -- Setup code that runs before each test
  end)

  after_each(function()
    -- Cleanup code that runs after each test
  end)

  describe("not_chat()", function()
    it("should recognize valid chat files", function()
      -- Create a temporary buffer with valid chat content
      local buf = vim.api.nvim_create_buf(false, true)
      local valid_content = {
        "# topic: Test Chat",
        "- file: test.md",
        "- model: gpt-4",
        "---",
        "Some chat content"
      }
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, valid_content)
      
      local result = gp.not_chat(buf, "test/chat.md")
      assert.is_nil(result)
      
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    it("should handle frontmatter in chat files", function()
      local buf = vim.api.nvim_create_buf(false, true)
      local content_with_frontmatter = {
        "---",
        "title: Test Chat",
        "date: 2024-01-07",
        "---",
        "# topic: Test Chat",
        "- file: test.md",
        "- model: gpt-4",
        "---",
        "Some chat content"
      }
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, content_with_frontmatter)
      
      local result = gp.not_chat(buf, "test/chat.md")
      assert.is_nil(result)
      
      vim.api.nvim_buf_delete(buf, { force = true })
    end)

    it("should reject invalid chat files", function()
      local buf = vim.api.nvim_create_buf(false, true)
      local invalid_content = {
        "Not a proper chat file",
        "Missing required headers"
      }
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, invalid_content)
      
      local result = gp.not_chat(buf, "test/not_chat.md")
      assert.is_not_nil(result)
      assert.matches("missing topic header", result)
      
      vim.api.nvim_buf_delete(buf, { force = true })
    end)
  end)
end)
