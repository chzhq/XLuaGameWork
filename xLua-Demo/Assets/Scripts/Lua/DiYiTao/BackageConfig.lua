--模块
local BackageConfig = {}

BackageConfig.BackageData = {}
function BackageConfig : Init()
   print('打开是配置脚本');
   BackageConfig : GetConfigData()
end
--读表
function BackageConfig:GetConfigData()
    local text = CS.UnityEngine.Resources.Load('Backage')
    local str = text.text --转化为字符串
    local lines ={}  --根据换行符切割字符串 行的分隔符\r\n
    for line in string.gmatch(str, "([^\r\n]+)") do
        table.insert(lines,line)
    end
    --遍历这张表  lua里面的遍历是默认从1开始
    for i=2, #lines do
        local line = lines[i]
        local data = {}
        local tabs = {}
        for value in string.gmatch(line, "([^,]+)") do 
           table.insert(tabs,value)
        end
        data.ID = tabs[1]
        data.Name = tabs[2]
        data.HeadIcon = tabs[3]
        data.Nums = tabs[4]
        data.Type = tabs[5]
        data.Level = tonumber(tabs[6]) --tonumber将字符串类型转化成数字类型
        table.insert(BackageConfig.BackageData,data)
        print(data.ID,data.Name,data.HeadIcon)
    end
    return BackageConfig.BackageData
end
--升级
function BackageConfig:Upgrade(level,tab)
    local datas = BackageConfig.BackageData
    for i=1,#datas do
        local temp = datas[i]
        if temp==tab then
            print("000",tab.Level)
            tab.Level=tab.Level+level
            print("111",tab.Level)
        end
    end
end
--排序
function BackageConfig:BackageDataSort()
   local datas = BackageConfig.BackageData
   local temp
   for i=1,#datas,1 do
      for j=1,#datas-1,1 do
         print(type(datas[j].Level))
         if(datas[j].Level<datas[j+1].Level) then
            temp = datas[j]
            datas[j] = datas[j+1]
            datas[j+1] = temp
         end
      end
   end
   return datas
end

return BackageConfig