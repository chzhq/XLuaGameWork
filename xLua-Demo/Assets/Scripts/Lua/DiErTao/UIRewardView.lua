
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
local RewardIcon = Reward:Find('Icon'):GetComponent('Image')
local BtnChouJiang = LeftReward:Find('BtnChouJiang'):GetComponent('Button')
local BtnLingQu = LeftReward:Find('BtnLingQu'):GetComponent('Button')

-- 抽奖控制
local SPIN_DURATION = 6
local START_INTERVAL = 0.05
local END_INTERVAL = 0.25

local rewardItems = {}
local configs = {}
local bagDatas = {}
local isSpinning = false
local spinElapsed = 0
local tickElapsed = 0
local currentInterval = START_INTERVAL
local currentIndex = -1
local targetIndex = -1
local targetRewardId = nil
local highlightGo = nil
local shouldStop = false
local function SafeLog(tag, ...)
    print('[UIRewardView][' .. tag .. ']', ...)
end

local function ClearHighlight()
    if highlightGo then
        highlightGo:SetActive(false)
        highlightGo = nil
    end
end

local function ApplyHighlight(idx)
    if idx < 0 or idx >= #rewardItems then
        return
    end
    local item = rewardItems[idx + 1]
    local bg = item:Find('img_bg').gameObject
    bg:SetActive(true)
    highlightGo = bg
end

local function FinishSpin()
    isSpinning = false
    shouldStop = false
    spinElapsed = 0
    tickElapsed = 0
    currentInterval = START_INTERVAL

    if BtnChouJiang then
        BtnChouJiang.interactable = true
    end

    if targetIndex >= 0 and targetIndex < #configs then
        local rewardConfig = configs[targetIndex + 1]
        targetRewardId = rewardConfig.ID
        SafeLog('FinishSpin', 'targetIndex:', targetIndex, 'rewardId:', targetRewardId)
        UIRewardView:ShowReward()
    end
end

local function AdvanceHighlight()
    local rewardCount = #rewardItems
    if rewardCount == 0 then
        return
    end

    ClearHighlight()
    currentIndex = (currentIndex + 1) % rewardCount
    ApplyHighlight(currentIndex)

    if shouldStop and currentIndex == targetIndex then
        FinishSpin()
    end
end

local function OnChouJiang()
    if isSpinning or #rewardItems == 0 then
        return
    end

    local rewardCount = math.min(8, #rewardItems)
    targetIndex = CS.UnityEngine.Random.Range(0, rewardCount)
    targetIndex = math.floor(targetIndex)
    if targetIndex >= rewardCount then
        targetIndex = rewardCount - 1
    end
    SafeLog('OnChouJiang', 'targetIndex selected:', targetIndex)
    currentIndex = -1
    spinElapsed = 0
    tickElapsed = 0
    currentInterval = START_INTERVAL
    shouldStop = false
    isSpinning = true
    targetRewardId = nil

    if BtnChouJiang then
        BtnChouJiang.interactable = false
    end
end

local function OnLingQu()
    if not targetRewardId then
        SafeLog('OnLingQu', '没有可领取的奖励')
        return
    end

    local data = UIRewardView:GetConfig(targetRewardId)
    if not data then
        SafeLog('OnLingQu', '未找到配置', targetRewardId)
        return
    end

    local sprite = UIRewardView:LoadSprite(data.Icon)
    local existing = UIRewardView:SetBackdatas(targetRewardId)

    if existing then
        existing.Num = existing.Num + 1
        local obj = existing.button
        local txtNum = obj.transform:Find('txtNum'):GetComponent('Text')
        txtNum.text = existing.Num
        SafeLog('OnLingQu', '叠加数量', targetRewardId, existing.Num)
        return
    end

    local backdata = {
        ID = targetRewardId,
        Num = 1
    }
    table.insert(bagDatas, backdata)

    local obj = CS.UnityEngine.GameObject.Instantiate(Item)
    obj.transform.parent = Content
    obj.transform.localScale = CS.UnityEngine.Vector3.one
    obj:SetActive(true)
    backdata.button = obj

    local icon = obj.transform:Find('Icon'):GetComponent('Image')
    icon.sprite = sprite

    local txtNum = obj.transform:Find('txtNum'):GetComponent('Text')
    txtNum.text = backdata.Num

    SafeLog('OnLingQu', '领取成功', targetRewardId)

    -- 清空当前奖励
    targetRewardId = nil
    if RewardIcon then
        RewardIcon.sprite = nil
        RewardIcon.gameObject:SetActive(false)
    end
end

function UIRewardView:SetBackdatas(rid)
    for i = 1, #bagDatas do
        local data = bagDatas[i]
        if data.ID == rid then
            return data
        end
    end
    return nil
end

function UIRewardView:Update()
    if not isSpinning then
        return
    end

    local deltaTime = CS.UnityEngine.Time.deltaTime
    spinElapsed = spinElapsed + deltaTime
    tickElapsed = tickElapsed + deltaTime

    local progress = math.min(spinElapsed / SPIN_DURATION, 1)
    local desiredInterval = START_INTERVAL + (END_INTERVAL - START_INTERVAL) * progress

    if tickElapsed >= currentInterval then
        AdvanceHighlight()
        tickElapsed = 0
        currentInterval = desiredInterval
    end

    if spinElapsed >= SPIN_DURATION then
        shouldStop = true
    end
end

function UIRewardView:GetConfig(rid)
    for i = 1, #configs do
        local config = configs[i]
        if config.ID == rid then
            return config
        end
    end
    return nil
end

function UIRewardView:ShowReward()
    if not targetRewardId then
        return
    end
    local data = UIRewardView:GetConfig(targetRewardId)
    if not data then
        SafeLog('ShowReward', '未找到配置', targetRewardId)
        return
    end
    local sprite = UIRewardView:LoadSprite(data.Icon)
    if RewardIcon then
        RewardIcon.sprite = sprite
        RewardIcon.gameObject:SetActive(true)
    else
        SafeLog('ShowReward', 'RewardIcon 丢失')
    end
    SafeLog('ShowReward', '显示奖励', targetRewardId)
end

function UIRewardView:GridReward()
    configs = ConfigData:GetConfigData()
    rewardItems = {}
    local childCount = math.min(GridReward.childCount, 8)
    for i = 0, childCount - 1 do
        local child = GridReward:GetChild(i)
        table.insert(rewardItems, child)
        local config = configs[i + 1]
        if config then
            local Icon = child:Find('Icon'):GetComponent('Image')
            Icon.sprite = UIRewardView:LoadSprite(config.Icon)
        end
        local bg = child:Find('img_bg')
        if bg then
            bg.gameObject:SetActive(false)
        end
    end
end

function UIRewardView:LoadSprite(name)
    local path = 'Head/' .. name
    return CS.UnityEngine.Resources.Load(path, typeof(CS.UnityEngine.Sprite))
end

function UIRewardView:InitAwake()
    BtnChouJiang.onClick:AddListener(OnChouJiang)
    BtnLingQu.onClick:AddListener(OnLingQu)
    UIRewardView:GridReward()
end

UIRewardView:InitAwake()

return UIRewardView  --设置为模块
