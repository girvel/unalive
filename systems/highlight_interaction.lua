return Tiny.processingSystem({
  filter = function(_, x) return x.was_interacted_with == false end,
  base_callback = "update"
})
