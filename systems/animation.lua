local FPS = 6

return Tiny.processingSystem({
  base_callback = "update",
  filter = Tiny.requireAll("animation"),
  process = function(_, entity, event)
    local dt = unpack(event)
    local animation = entity.animation
    if animation.paused then return end
    animation.frame = animation.frame + dt * FPS

    if not animation.pack[animation.current] or math.floor(animation.frame) > #animation.pack[animation.current] then
      entity:animate("idle")

      if entity._on_animation_end then
        entity:_on_animation_end()
        entity._on_animation_end = nil
      end
    end

    entity:animation_refresh()
  end,
})
