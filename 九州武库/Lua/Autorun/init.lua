JZ_Main = {}  --初始化
JZ_Main.Version = "1.0"   --版本号
JZ_Main.VersionNum = 01000000   --版本号
JZ_Main.Path = table.pack(...)[1]  --获取路径

if Game.IsSingleplayer or SERVER then
	dofile(JZ_Main.Path.."/Lua/Server/tsmcombatship.lua")
	dofile(JZ_Main.Path.."/Lua/Scripts/Shared/Firesupport.lua")
	dofile(JZ_Main.Path.."/Lua/Scripts/Shared/Shared.lua")
end

if CLIENT then  --仅客户端
	dofile(JZ_Main.Path.."/Lua/Scripts/Client/weapon_zoom.lua")  --编译
end