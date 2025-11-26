local UnityEngine = CS.UnityEngine


local cube = UnityEngine.GameObject.Find("Cube")

-- 检查是否找到立方体
if cube == nil then
    print("错误：未找到名为'Cube'的物体！")
    return
end

-- 获取立方体的Transform组件
local cubeTransform = cube.transform

-- 定义旋转速度
local rotateSpeed = 50

-- 每帧更新旋转
local function Update()
    -- 绕Y轴旋转
    cubeTransform:Rotate(UnityEngine.Vector3.up, rotateSpeed * UnityEngine.Time.deltaTime)
end

-- 将Update函数注册到XLua的更新事件
return { Update = Update }