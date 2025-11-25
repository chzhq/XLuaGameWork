
local UIShopView = {}
local GameObject = CS.UnityEngine.GameObject
local Resources =  CS.UnityEngine.Resources
local ShopData = require('DiSiTao/ShopData')
local UIHeroDescView = require('DiSiTao/UIHeroDescView')

local UIRoot = GameObject.Find('UIRoot') --先找到根节点
local ShopView = UIRoot.transform:Find('UIShopView')
local HeroDescView =  UIRoot.transform:Find('UIHeroDescView') --获取到视图的页面

local BtnShopAll = ShopView:Find("BtnShopAll"):GetComponent('Button')
local BtnShopType1 = ShopView:Find('BtnShopType1'):GetComponent('Button')
local BtnShopType2 = ShopView:Find('BtnShopType2'):GetComponent('Button')
local BtnShopType3 = ShopView:Find('BtnShopType3'):GetComponent('Button')
local BtnShopType4 = ShopView:Find('BtnShopType4'):GetComponent('Button')

local Content = ShopView:Find('ScrollView/Viewport/Content')
local HeroItem = ShopView:Find('HeroItem').gameObject

local TypeShopData={}  --在切分页的时候，做赋值

function UIShopView : Open()
    print('商城界面....')
    UIShopView :ShowAllData()
end
--
function UIShopView:Init()
   
    BtnShopAll.onClick:AddListener(UIShopView.ShopAll)
    BtnShopType1.onClick:AddListener(UIShopView.ShopType1)
    BtnShopType2.onClick:AddListener(UIShopView.ShopType2)
    BtnShopType3.onClick:AddListener(UIShopView.ShopType3)
    BtnShopType4.onClick:AddListener(UIShopView.ShopType4)
end


--显示所有数据
function UIShopView :ShowAllData()
    UIShopView:ShowHeroData(ShopData);
end

--只显示当个英雄数据的UI
function UIShopView:ShowHeroData(HeroDatas)
    --先清空之前的内容
    local count = Content.childCount
    for i=count-1,0,-1 do
       local obj = Content:GetChild(i).gameObject
       GameObject.DestroyImmediate(obj);
    end

    for i=1,#HeroDatas do 
        local data = HeroDatas[i]
        local item = GameObject.Instantiate(HeroItem)
        item.transform.parent = Content
        --print(data.Type,data.Name)
        item:SetActive(true)
        local Icon = item.transform:Find('Icon'):GetComponent('Image')
        local Name = item.transform:Find('Name'):GetComponent('Text')
        local sprite  = UIShopView:LoadIcon(data.Icon)
        Icon.sprite = sprite
        --print(data.Name)
        Name.text = data.Name

        local button = item:GetComponent('Button')
        button.onClick:AddListener(
            function()
                UIHeroDescView:Open(data,HeroDatas)
                HeroDescView.gameObject:SetActive(true)
            end
        )
    end
end

function UIShopView:LoadIcon(iconname)
    local path = 'Hero/'..iconname
    local sprite = Resources.Load(path,typeof(CS.UnityEngine.Sprite))
    return sprite
end

function UIShopView:GetDataByType(heroType)
    local TypeDatas={}
    for i=1,#ShopData do
        local data = ShopData[i]
        if data.Type == heroType then
            print(heroType,data.Type,data.Name)
            table.insert(TypeDatas,data)
        end
    end
    return TypeDatas
end
function UIShopView:ShopAll()
   UIShopView:ShowHeroData(ShopData);
end
function UIShopView:ShopType1()
   local datas = UIShopView:GetDataByType(1)
   UIShopView:ShowHeroData(datas);
end
function UIShopView:ShopType2()
   local datas = UIShopView:GetDataByType(2)
   UIShopView:ShowHeroData(datas);
end
function UIShopView:ShopType3()
   local datas = UIShopView:GetDataByType(3)
   UIShopView:ShowHeroData(datas);
end
function UIShopView:ShopType4()
   local datas = UIShopView:GetDataByType(4)
   UIShopView:ShowHeroData(datas);
end
UIShopView:Init()
return UIShopView