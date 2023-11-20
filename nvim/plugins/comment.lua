require('nvim_comment').setup({
      marker_mapping = true

    , comment_empty_trim_whitespace = false
    , create_mappings = true
    , comment_empty = false
    , line_mapping = "<leader>lc", operator_mapping = "<leader>c", comment_chunk_text_object = "ic"
})
