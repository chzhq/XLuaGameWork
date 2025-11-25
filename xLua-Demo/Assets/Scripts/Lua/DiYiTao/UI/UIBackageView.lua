
local UIBackageView = {}

local Config = require('DiYiTao/BackageConfig')

local backageView = CS.UnityEngine.GameObject.Find('Canvas/UIBackageView');
local Content = backageView.transform:Find('ScrollView/Viewport/Content')

local BtnRoot = backageView.transform:Find("BtnRoot")
local BtnAll = BtnRoot:Find("BtnAll"):GetComponent("Button")
local BtnZhuangbei = BtnRoot:Find("BtnZhuangbei"):GetComponent("Button")
local BtnHaoGanDu = BtnRoot:Find("BtnHaoGanDu"):GetComponent("Button")
local BtnXiaoHaoPin = BtnRoot:Find("BtnXiaoHaoPin"):GetComponent("Button")
local BtnCaiLiao = BtnRoot:Find("BtnCaiLiao"):GetComponent("Button")
local BtnDuiHuan =  BtnRoot:Find("BtnDuiHuan"):GetComponent("Button")
local BtnShengJi = backageView.transform:Find('BtnShengJi'):GetComponent('Button')
local txt_Nums = backageView.transform:Find('txt_Nums'):GetComponent('Text')
local Upgrade = backageView.transform:Find('Upgrade')
local UpgradeIcon = Upgrade:Find('Item/Icon'):GetComponent('Image')
local BtnUpgrade = Upgrade:Find('BtnUpgrade'):GetComponent('Button')
local TxtNum = Upgrade:Find('Item/TxtNum'):GetComponent('Text')
local TxtLevel = Upgrade:Find('Item/TxtLevel'):GetComponent('Text')
local BtnZhengLi = backageView.transform:Find('BtnZhengLi'):GetComponent('Button')


local temp --变量需要在前面定义
local IconData -- 变量需要在前面定义
local tempData = {} -- 变量需要在前面定义
local buttonType 

function UIBackageView : Open()
    print("打开背包界面");
    Config:Init()
    UIBackageView:ShowBackData()
    UIBackageView:Init()
end
function UIBackageView:Init()
    BtnAll.onClick:AddListener(OnAll)
    BtnZhuangbei.onClick:AddListener(OnZhuangbei)
    BtnHaoGanDu.onClick:AddListener(OnHaoGanDu)
    BtnXiaoHaoPin.onClick:AddListener(OnXiaoHaoPin)
    BtnCaiLiao.onClick:AddListener(OnCaiLiao)
    BtnDuiHuan.onClick:AddListener(OnDuiHuan)
    BtnShengJi.onClick:AddListener(OnBtnShengJi)
    BtnUpgrade.onClick:AddListener(OnBtnUpgrade)
    BtnZhengLi.onClick:AddListener(OnBtnZhengLi)
end
--整理按钮
function OnBtnZhengLi()
   Config:BackageDataSort()
   ShowUIData()
end
--升级面板中的升级
function OnBtnUpgrade()
    Upgrade.gameObject:SetActive(false)
    Config:Upgrade(1,tempData)
    ShowUIData()
end
function ShowUIData()
    if buttonType=='0' then
       UIBackageView:ShowBackData()
    elseif buttonType=='1' then
       ShowChildUI('1')
    elseif buttonType=='2' then
       ShowChildUI('2')
    elseif buttonType=='3' then
       ShowChildUI('3')
    elseif buttonType=='4' then
       ShowChildUI('4')
    elseif buttonType=='5' then
       ShowChildUI('5')
    end
end
--升级
function OnBtnShengJi()
   if temp ~=nil then
      Upgrade.gameObject:SetActive(true)
      UpgradeIcon.sprite = IconData
      TxtNum.text = tempData.Nums
      TxtLevel.text = tempData.Level
   end
end

function OnAll()
    UIBackageView:ShowBackData()
end
function ShowChildUI(Type)
    local zhuangbei={}
    local datas = Config.BackageData
    for i=1,#datas do
        local data = datas[i]
       if data.Type == Type then
          table.insert(zhuangbei,data)
       end
    end
    for i=1,#zhuangbei do
        ShowUI(i,zhuangbei)
    end
    index = #zhuangbei --这个是取表中的数量
    for i=index,9,1 do
        local child = Content:GetChild(i)--2,3,4,5,6,7,8,9
        child.gameObject:SetActive(false)
    end
    ShowBackItemNums(index,10)
end
function OnZhuangbei()
    buttonType = '1'
    ShowChildUI('1')
end
function OnHaoGanDu()
    buttonType = '2'
    ShowChildUI('2')
end
function OnXiaoHaoPin()
    buttonType = '3'
    ShowChildUI('3')
end
function OnCaiLiao()
    buttonType = '4'
    ShowChildUI('4')
end
function OnDuiHuan()
    buttonType = '5'
    ShowChildUI('5')
end
--左下角
function ShowBackItemNums(currnum,maxnum)
    txt_Nums.text = currnum..'/'..maxnum
end
function UIBackageView:ShowBackData()
    buttonType = '0'
    local datas = Config.BackageData
    for i=1,#datas do
        ShowUI(i,datas)
    end
    ShowBackItemNums(10,10)
end

function ShowUI(i,tables)
    local child = Content:GetChild(i-1)
    local TxtNum = child:Find('TxtNum'):GetComponent('Text')
    local data = tables[i]
    TxtNum.text =data.Nums
    local icon = UIBackageView:LoadSprite(data.HeadIcon)
    local imgIcon = child:Find("Icon"):GetComponent('Image')
    imgIcon.sprite = icon
    local TxtLevel = child:Find('TxtLevel'):GetComponent('Text')
    TxtLevel.text = data.Level
    child.gameObject:SetActive(true)
    Button = child:GetComponent('Button')
    Button.onClick:AddListener(
        function()
           IconData = icon
           tempData = data
           OnChuanCan(child)
        end
    );
end

function OnChuanCan(child)
    if(temp~=nil) then
       temp.gameObject:SetActive(false)
    end
    local Check = child:Find("Check")
    Check.gameObject:SetActive(true)
    temp = Check;
end

function UIBackageView:LoadSprite(HeadIcon)
    local path = 'Head/'..HeadIcon
    local icon = CS.UnityEngine.Resources.Load(path,typeof(CS.UnityEngine.Sprite))
    return icon
end

return  UIBackageView