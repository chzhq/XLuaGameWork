
local UITeamUpPanel = {}
local GameObject  = CS.UnityEngine.GameObject
local FriendData = require('DiLiuTao/FriendData')

local UIRoot = GameObject.Find('UIRoot')
local TeamUpPanel = UIRoot.transform:Find('UITeamUpPanel')
local BtnClose = TeamUpPanel:Find('BtnClose'):GetComponent('Button')
local PlayerItem = TeamUpPanel:Find('PlayerItem').gameObject
local FriendItem = TeamUpPanel:Find('FriendItem').gameObject
local FrContent = TeamUpPanel:Find('ScrollView/Viewport/Content')
local PlContent = TeamUpPanel:Find('Content')
local txtTitle = TeamUpPanel:Find('txtTitle'):GetComponent('Text')

local mode =0
local index = 1
function UITeamUpPanel :Init()
    BtnClose.onClick:AddListener(UITeamUpPanel.OnClose)
end
function UITeamUpPanel:OnClose()
    TeamUpPanel.gameObject:SetActive(false)
end
--
function UITeamUpPanel :Open(_mode)
    mode = _mode
    if mode == 1 then
        txtTitle.text = '1V1'
    elseif mode == 3 then
        txtTitle.text = '3V3'
    elseif mode == 5 then
        txtTitle.text = '5V5'
    end
    index = 1
    UITeamUpPanel : ShowFriendList()
    UITeamUpPanel:ShowPlayerList()
end
--显示邀请的对战好友
function UITeamUpPanel:ShowPlayerList()
   
    --删除之前的数据
    for i= PlContent.childCount-1,0,-1 do
        local obj =  PlContent:GetChild(i).gameObject
        GameObject.DestroyImmediate(obj)
    end

    for i=1,mode do
        local item = GameObject.Instantiate(PlayerItem)
        item.transform.parent = PlContent
        item:SetActive(true)
        local head = item.transform:Find('head'):GetComponent('Image')
        local txtName = item.transform:Find('txtName'):GetComponent('Text')
        if i>1 then
           head.gameObject:SetActive(false)
           txtName.text = ''
        end
    end

end


--显示好友列表
function UITeamUpPanel : ShowFriendList()
   
    --删除之前的数据
    for i= FrContent.childCount-1,0,-1 do
        local obj =  FrContent:GetChild(i).gameObject
        GameObject.DestroyImmediate(obj)
    end

    for i=1,#FriendData do 
        local data=FriendData[i]
        local item = GameObject.Instantiate(FriendItem)
        item.transform.parent = FrContent
        item:SetActive(true)

        local TxtName = item.transform:Find('TxtName'):GetComponent('Text')
        TxtName.text = data.Name
        local TxtLevel = item.transform:Find('TxtLevel'):GetComponent('Text')
        TxtLevel.text = data.Level
        local TxtRank = item.transform:Find('TxtRank'):GetComponent('Text')
        TxtRank.text = data.Rank
        local Head = item.transform:Find('Head'):GetComponent('Image')
        Head.sprite =UITeamUpPanel:LoadSprite(data.Head)

        local BtnInvitation = item.transform:Find('BtnInvitation'):GetComponent('Button')
        BtnInvitation.onClick:AddListener(
            function()
               UITeamUpPanel : OnYaoQing(data)
            end
            )
    end
end 

--邀请
function UITeamUpPanel : OnYaoQing(data)
   
    if index < PlContent.childCount then
        local child = PlContent:GetChild(index)
        local head =  child:Find('head'):GetComponent('Image')
        head.sprite = UITeamUpPanel:LoadSprite(data.Head)
        head.gameObject:SetActive(true)
        local txtName = child:Find('txtName'):GetComponent('Text')
        txtName.text = data.Name
        index=index + 1
    end
end



function UITeamUpPanel:LoadSprite(name)
    local path = 'Head/'..name
    local sprite =  CS.UnityEngine.Resources.Load(path,typeof(CS.UnityEngine.Sprite))
    return  sprite
end

UITeamUpPanel :Init()
return UITeamUpPanel