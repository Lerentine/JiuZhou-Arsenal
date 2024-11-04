EFOV = {}  --初始化
EFOV.Name="T.S.M Enhanced FOV"  --MOD名称
EFOV.Version = "1.0"   --版本号
EFOV.VersionNum = 01000000   --版本号
EFOV.Path = table.pack(...)[1]  --获取路径


if CLIENT then  --仅客户端
	Timer.Wait(function()  --等待执行下列代码
		local runstring = "\n/// T.S.M Enhanced FOV Version"..EFOV.Version.." ///\n"  --打印模组名和版本号
		print(runstring)  
	end,1)
	dofile(EFOV.Path.."/Lua/Scripts/Client/weapon_zoom.lua")  --编译
end