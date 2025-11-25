
local UIVersusPanel = {}
local GameObject = CS.UnityEngine.GameObject
local UITeamUpPanel = require('DiLiuTao/UITeamUpPanel')

local UIRoot = GameObject.Find('UIRoot')
local VersusPanel = UIRoot.transform:Find('UIVersusPanel')
local TeamUpPanel = UIRoot.transform:Find('UITeamUpPanel')

local Btn1V1 = VersusPanel:Find('Btn1V1'):GetComponent('Button')
local Btn3V3 = VersusPanel:Find('Btn3V3'):GetComponent('Button')
local Btn5V5 = VersusPanel:Find('Btn5V5'):GetComponent('Button')
local BtnClose = VersusPanel:Find('BtnClose'):GetComponent('Button')

function UIVersusPanel:Init()
    Btn1V1.onClick:AddListener(UIVersusPanel.OnBtn1V1)
    Btn3V3.onClick:AddListener(UIVersusPanel.OnBtn3V3)
    Btn5V5.onClick:AddListener(UIVersusPanel.OnBtn5V5)
    BtnClose.onClick:AddListener(UIVersusPanel.OnBtnClose)
end
function UIVersusPanel:OnBtnClose()
    VersusPanel.gameObject:SetActive(false);
end

function UIVersusPanel : OnBtn1V1()
    TeamUpPanel.gameObject:SetActive(true);
    UITeamUpPanel:Open(1)
end
function UIVersusPanel : OnBtn3V3()
    TeamUpPanel.gameObject:SetActive(true);
    UITeamUpPanel:Open(3)
end
function UIVersusPanel : OnBtn5V5()
    TeamUpPanel.gameObject:SetActive(true);
    UITeamUpPanel:Open(5)
end


UIVersusPanel:Init()
return UIVersusPanel