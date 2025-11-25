


local UIMainView = {}

local UIBackageView = require('DiYiTao/UI/UIBackageView')

local mainview = CS.UnityEngine.GameObject.Find('Canvas/UIMainView');
local backageView = CS.UnityEngine.GameObject.Find('Canvas/UIBackageView');
backageView:SetActive(false);

function UIMainView.Init()

    local BtnBackage = mainview.transform:Find('BtnBackage')
    local button = BtnBackage:GetComponent('Button')
    button.onClick:AddListener(OnClick)
end
function OnClick()
    print(backageView)
    backageView:SetActive(true)
    UIBackageView:Open()
end

UIMainView.Init()

return UIMainView