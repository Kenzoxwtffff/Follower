local plugin_label = "Peer Pressure"
local menu = {}

menu.elements = {
  main_tree = tree_node:new(0),
  main_toggle = checkbox:new(false, get_hash(plugin_label .. "_main_toggle")),
  follow_toggle = checkbox:new(false, get_hash(plugin_label .. "_Follow")),
  ally_id_input = input_text:new(get_hash(plugin_label .. "_ally_id_input"))  
}

function menu.render()
  if not menu.elements.main_tree:push("Peer Pressure") then
    return
  end

  menu.elements.main_toggle:render("Enable", "Keypress R + Cursor on ally to find ID")
  if not menu.elements.main_toggle:get() then
    menu.elements.main_tree:pop()
    return
  end

  menu.elements.follow_toggle:render("Follow Leader", "Follows Party Leader")

  menu.elements.ally_id_input:render("Ally ID", "Enter the Ally's ID", false, "", "")
  
  menu.elements.main_tree:pop()
end

return menu

