
local UIRewardView = {} -- 创建表 设置为模块
local ConfigData = require('DiErTao/RewardConfig') --加载模块

local RewardView = CS.UnityEngine.GameObject.Find('Canvas/UIRewardView');
--获取unity组件
local LeftReward = RewardView.transform:Find('LeftReward')
local RightBackage = RewardView.transform:Find('RightBackage')
local Content = RightBackage:Find('ScrollView/Viewport/Content')
local Item = RightBackage:Find('Item').gameObject
local GridReward = LeftReward:Find('GridReward')
local Reward = LeftReward:Find('Reward')
local BtnChouJiang = LeftReward:Find('BtnChouJiang'):GetComponent('Button')
local BtnLingQu = LeftReward:Find('BtnLingQu'):GetComponent('Button')
local _time = CS.UnityEngine.Time.time;
local IsChouKa=false;
local index = 0;
local count = 0;
local configs = {};
local RewardID;

local backdatas ={}

--初始化
function UIRewardView : InitAwake()
    --ConfigData:Init();
    BtnChouJiang.onClick:AddListener(OnChouJiang)
    BtnLingQu.onClick:AddListener(OnLingQu)
    UIRewardView:GridReward();--获取抽奖信息
end

function UIRewardView : SetBackdatas(RID)
   for i=1,#backdatas do
      local data = backdatas[i]
      if(data.ID == RID) then
         return data
      end
   end
   return false
end 
--领取奖品   当滚动框停止后，可以点击领取物品领取选中框滚到的对应位置上的奖品
function OnLingQu()   -- 奖品进入背包

    local data = UIRewardView:GetConfig(RewardID)
    local sprite = UIRewardView:LoadSprite(data.Icon)
    local backdata = {} --
    backdata.ID = RewardID --当前的物品ID
    local ReData = UIRewardView : SetBackdatas(RewardID)
    if ReData then
        ReData.Num = ReData.Num +1
        --要解决的已存在的物品的数量显示 周一继续讲解
        print("ReData.Num = ",ReData.Num)
        local obj = ReData.button
        local txtNum = obj.transform:Find('txtNum'):GetComponent('Text')
        txtNum.text = ReData.Num 
    else   --点击按钮领取物品正确
        backdata.Num = 1 --累计计数
        table.insert(backdatas,backdata)
        local obj = CS.UnityEngine.GameObject.Instantiate(Item)
        obj.transform.parent = Content
        backdata.button = obj  --这个是当前对应的按钮
        local icon = obj.transform:Find('Icon'):GetComponent('Image')
        icon.sprite = sprite;
        local txtNum = obj.transform:Find('txtNum'):GetComponent('Text')
        txtNum.text = backdata.Num 
        obj:SetActive(true);
    end
end

--编写抽奖过程，点击开始抽奖后选中框开始滚动,随机滚动次数
function UIRewardView : Update()
    if IsChouKa then
        if CS.UnityEngine.Time.time - _time > 0.1 then
            print("index",index,count)
            UIRewardView:OnZhuanDongReward()
            index = index +1;
            if index > count then
                IsChouKa = false;
                local i = (index-1) % 8 -- 0 - 7
                RewardID = configs[i+1].ID
                UIRewardView:ShowReward()
                print("RewardID",RewardID)
            end
            _time = CS.UnityEngine.Time.time;
        end
    end
end
--根据ID实现获取单个表
function UIRewardView:GetConfig(RID)
    local data = {}
    for i=1,#configs do
        local config = configs[i]
        if config.ID == RID then
            data = config
        end
    end 
    return data
end

function UIRewardView:ShowReward()
    local Icon = Reward:Find('Icon'):GetComponent('Image')
    local data = UIRewardView:GetConfig(RewardID)
    local sprite = UIRewardView:LoadSprite(data.Icon)
    Icon.sprite = sprite
    
end

local tempbg;
function UIRewardView:OnZhuanDongReward()
    if tempbg then
       tempbg:SetActive(false);
    end
    local i = index % 8 -- 0 - 7
    local tran = GridReward:GetChild(i)
    local img_bg = tran:Find('img_bg').gameObject
    img_bg:SetActive(true);
    tempbg = img_bg
end
--抽奖  编写抽奖过程，点击开始抽奖后选中框开始滚动,随机滚动次数
function OnChouJiang()
   IsChouKa = true
   index = 0;
   count = CS.UnityEngine.Random.Range(9, 32)
end
--抽奖池数据赋值
function UIRewardView:GridReward()
    configs = ConfigData:GetConfigData()
    local count = GridReward.childCount;
    print(type(configs),#configs,count)
    for i=0,count-1 do  --下标从0开始
       local child = GridReward:GetChild(i) --符合C#里面unity获取子物体的习惯
       local config = configs[i+1] --lua里面的下标默认是从1开始
       print('Icon',config.Icon)
       local Icon = child:Find('Icon'):GetComponent('Image')
       local sprite = UIRewardView:LoadSprite(config.Icon)
       Icon.sprite = sprite
    end
end

function UIRewardView:LoadSprite(name)
    local path = 'Head/'..name
    local sprite =  CS.UnityEngine.Resources.Load(path,typeof(CS.UnityEngine.Sprite))
    return  sprite
end

UIRewardView:InitAwake()

return UIRewardView  --设置为模块
