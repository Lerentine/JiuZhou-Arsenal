local function lerp(a,b,t)  --定义函数
	return a* (1- t) + b * t 
end


Hook.Patch("Barotrauma.Character", "ControlLocalPlayer", function(instance, ptable)  --补Hook
    local character = instance  --变量

    if not character then return end  
    if Game.GameSession.IsTabMenuOpen then return end
    if GUI.GUI.PauseMenuOpen then return end
    if GUI.KeyboardDispatcher.Subscriber then return end
	  if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("mountableweapon",true,2) or character.HasEquippedItem("mountableweapon",true,4))  and not (character.SelectedItem or (character.HasEquippedItem("tsm_farsight",true,4) or character.HasEquippedItem("tsm_farsight",true,2))) then  --右键且拿着武器且没与物品交互
        Screen.Selected.Cam.OffsetAmount = lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.6)  --设置偏移量
        end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("tsm_farsight",true,4) or character.HasEquippedItem("tsm_farsight",true,2))  and not character.SelectedItem then  --右键且拿着武器且没与物品交互
        Screen.Selected.Cam.OffsetAmount = lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.7)  --设置偏移量
        end
    if PlayerInput.SecondaryMouseButtonHeld() and (character.HasEquippedItem("tsm_sight",true,4) or character.HasEquippedItem("tsm_sight",true,2))  and not (character.SelectedItem or (character.HasEquippedItem("mountableweapon",true,4) or character.HasEquippedItem("mountableweapon",true,2))) then  --右键且拿着武器且没与物品交互
        Screen.Selected.Cam.OffsetAmount = lerp(Screen.Selected.Cam.OffsetAmount, 0, -0.65)  --设置偏移量
        end
end, Hook.HookMethodType.After)