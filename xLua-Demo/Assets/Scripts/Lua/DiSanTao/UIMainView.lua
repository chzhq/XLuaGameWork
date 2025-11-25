
local UIMainView = {} -- 构建一个模块
local GameObject = CS.UnityEngine.GameObject

local HeroData = require('DiSanTao/HeroData')

local RootView = GameObject.Find("Canvas/UIMainView")
RootView = RootView.transform
local RankBox = RootView:Find('RankBox')
local Content = RankBox:Find('ScrollView/Viewport/Content')
local RankItem = RankBox:Find('RankItem')

local HeroPopup = RootView:Find('HeroPopup')
local BtnClose = HeroPopup:Find('BtnClose'):GetComponent('Button')

function UIMainView:Init()
   print('初始化')
   BtnClose.onClick:AddListener(OnCloseHeroPopup)
   UIMainView:OnRank()
end
function OnCloseHeroPopup()
    HeroPopup.gameObject:SetActive(false)
end
--排行榜计算
function UIMainView:OnRank()
    --冒泡排序
    local RankData = HeroData
    local temp;
    for i=1,#RankData do
       for j=1,#RankData-i do
          if RankData[j].Battle <RankData[j+1].Battle then
              temp = RankData[j]
              RankData[j] = RankData[j+1]
              RankData[j+1] = temp
          end
       end
    end
    UIMainView:UpdateHeroData()
end
--遍历配表
function UIMainView:UpdateHeroData() 
   for i=1,#HeroData,1 do
       local hero = HeroData[i]
       local item = GameObject.Instantiate(RankItem.gameObject)
       item.transform.parent = Content;
       item:SetActive(true)
       UIMainView:ShowUI(item,hero,i)
   end
end
local lastChecked;
function UIMainView:ShowUI(item,hero,rank)

   local Head = item.transform:Find('Head'):GetComponent('Image')
   local sprite = UIMainView:LoadSprite(hero.Icon)
   Head.sprite = sprite
   local TxtName = item.transform:Find('TxtName'):GetComponent("Text")
   TxtName.text = hero.Name
   local TxtBattle = item.transform:Find('TxtBattle'):GetComponent('Text')
   TxtBattle.text = '战力：'..hero.Battle
   local TxtRank = item.transform:Find('TxtRank'):GetComponent('Text')
   TxtRank.text = rank
   
   local button = Head.transform:GetComponent('Button');
   button.onClick:AddListener(
      function()
         if lastChecked then
            lastChecked.gameObject:SetActive(false);
         end
         local Checked = item.transform:Find('Checked')
         Checked.gameObject:SetActive(true)
         lastChecked = Checked
         UIMainView:OnHeroPopup(hero,rank)
      end
   )
end
--显示英雄的弹出窗
function UIMainView:OnHeroPopup(hero,rank)
    HeroPopup.gameObject:SetActive(true)
    local Head = HeroPopup.transform:Find('Head'):GetComponent('Image')
    local TxtBattle = HeroPopup.transform:Find('TxtBattle'):GetComponent('Text')
    local TxtName = HeroPopup.transform:Find('TxtName'):GetComponent("Text")
    local TxtLevel =  HeroPopup.transform:Find('TxtLevel'):GetComponent("Text")
    local sprite = UIMainView:LoadSprite(hero.Icon)
    Head.sprite = sprite
    TxtBattle.text = hero.Battle
    TxtName.text = hero.Name
    TxtLevel.text = hero.Level
end

function UIMainView:LoadSprite(name)
    local path = 'Head/'..name
    local sprite =  CS.UnityEngine.Resources.Load(path,typeof(CS.UnityEngine.Sprite))
    return  sprite
end

UIMainView:Init()

return UIMainView 