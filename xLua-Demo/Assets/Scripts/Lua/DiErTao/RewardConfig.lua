
RewardConfig = {}

RewardConfig.Configs = {} --理解成我们C#里面的List

function RewardConfig:Init()
    print('RewardConfig:Init')
    RewardConfig:GetConfigData()
end
--读表
function RewardConfig:GetConfigData()
    local config = CS.UnityEngine.Resources.Load('Reward');
    local configData = config.text;
    local lines = {}
    for line in string.gmatch(configData,"([^\r\n]+)") do
        table.insert(lines,line)
    end
    for i=2,#lines do
        local tabs = lines[i]
        local datas = {}
        local config = {}
        for tab in string.gmatch(tabs,"([^,]+)") do
            table.insert(datas,tab)
        end
        config.ID = tonumber(datas[1])
        config.Name = datas[2]
        config.Icon = datas[3]
        config.Desc = datas[4]
        table.insert(RewardConfig.Configs,config)
        
    end
    print('RewardConfig.Configs',RewardConfig.Configs[1].Name)
    return RewardConfig.Configs
end




return RewardConfig