
local UIHeroDescView = {} --英雄详情模块
local GameObject = CS.UnityEngine.GameObject
local Resources = CS.UnityEngine.Resources
local Sprite = CS.UnityEngine.Sprite

local UIRoot = GameObject.Find('UIRoot') --先找到根节点
local heroDescView = UIRoot.transform:Find('UIHeroDescView')

local txtName = heroDescView:Find('txtName'):GetComponent('Text') --Text文本节点
local txtBattle = heroDescView:Find('txtBattle'):GetComponent('Text') --Text文本节点
local txtHp = heroDescView:Find('txtHp'):GetComponent('Text')  --Text文本节点
local txtMp = heroDescView:Find('txtMp'):GetComponent('Text')  --Text文本节点

local BtnDefine = heroDescView:Find('BtnDefine'):GetComponent('Button')  --Button文本节点
local BtnRight =  heroDescView:Find('BtnRight'):GetComponent('Button') --Button文本节点
local BtnLeft = heroDescView:Find('BtnLeft'):GetComponent('Button')  --Button文本节点

local HeroIcon = heroDescView:Find('HeroIcon'):GetComponent('Image')
local HeroDatas ={}
local index=1
--初始化的方法
function UIHeroDescView:Init()
   BtnDefine.onClick:AddListener(UIHeroDescView.OnDefine)
   BtnRight.onClick:AddListener(UIHeroDescView.OnRight)
   BtnLeft.onClick:AddListener(UIHeroDescView.OnLeft)
end
--打开的方法
function UIHeroDescView:Open(herodata,_HeroDatas)
    HeroDatas = _HeroDatas
    UIHeroDescView:ShowUI(herodata)
end
function UIHeroDescView:ShowUI(herodata) --复用
    print(herodata.Name,herodata.Icon)
    txtName.text = herodata.Name
    txtBattle.text = herodata.Battle
    txtHp.text = 100
    txtMp.text = 200
    local icon=  UIHeroDescView:LoadIcon(herodata.Icon)
    HeroIcon.sprite = icon
end
function UIHeroDescView:LoadIcon(iconname)
    local path = 'Hero/'..iconname
    local sprite = Resources.Load(path,typeof(Sprite))
    return sprite
end

function UIHeroDescView:OnDefine()
   heroDescView.gameObject:SetActive(false)
end
function UIHeroDescView:OnRight()
   index=index+1
   if index> #HeroDatas then
       index = #HeroDatas
   end
   local data = HeroDatas[index]
   UIHeroDescView:ShowUI(data)
end
function UIHeroDescView:OnLeft()
   index=index-1
   if index < 1 then
      index =1
   end
   local data = HeroDatas[index]
   UIHeroDescView:ShowUI(data)
end

UIHeroDescView:Init()
return UIHeroDescView