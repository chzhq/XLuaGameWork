using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using XLua;

public class HyLuaMananger : MonoBehaviour
{
    public LuaEnv luaEnv;
    void Start()
    {
        luaEnv = new LuaEnv();
        luaEnv.AddLoader(OnLoadLuaFile);
        luaEnv.DoString("require 'main'");
    }
    private byte[] OnLoadLuaFile(ref string filepath)
    {
        filepath = Application.dataPath + "/Scripts/Lua/" + filepath + ".lua";
        Debug.Log(filepath);
        if (File.Exists(filepath))
        {
            return File.ReadAllBytes(filepath);
        }
        else
        {
            return null;
        }
    }
    void Update()
    {
        luaEnv.Global.Get<Action>("Update").Invoke();
    }
}
