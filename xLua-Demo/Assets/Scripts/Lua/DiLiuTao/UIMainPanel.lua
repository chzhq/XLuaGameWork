
local UIMainPanel = {}
local GameObject = CS.UnityEngine.GameObject
local UIVersusPanel = require('DiLiuTao/UIVersusPanel')

local UIRoot = GameObject.Find('UIRoot')
local MainPanel = UIRoot.transform:Find('UIMainPanel')
local VersusPanel = UIRoot.transform:Find('UIVersusPanel')

local BtnBattle = MainPanel:Find('BtnBattle'):GetComponent('Button')

function UIMainPanel : Init()
    BtnBattle.onClick:AddListener(UIMainPanel.OnBattle)
end

function UIMainPanel:OnBattle()
    VersusPanel.gameObject:SetActive(true)
end

UIMainPanel : Init()
return UIMainPanel