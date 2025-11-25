
local UIMainView = {}
local GameObject = CS.UnityEngine.GameObject --

local UIShopView = require('DiSiTao/UIShopView') ---

local UIRoot = GameObject.Find('UIRoot') --先找到根节点
local RootView = UIRoot.transform:Find('UIMainView')
local ShopView = UIRoot.transform:Find('UIShopView').gameObject
local BtnShop = RootView:Find('BtnShop'):GetComponent('Button')

function UIMainView:Init()
    BtnShop.onClick:AddListener(UIMainView.OnBtnShop);
end

function UIMainView:OnBtnShop()
    ShopView:SetActive(true)
    UIShopView:Open()
end

UIMainView:Init()

return UIMainView  --模块