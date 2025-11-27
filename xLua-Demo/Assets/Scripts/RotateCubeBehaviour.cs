using System;
using System.IO;
using UnityEngine;
using XLua;

[DisallowMultipleComponent]
public class RotateCubeBehaviour : MonoBehaviour
{
    private const string LuaModuleName = "RotateCube";

    private LuaEnv _luaEnv;
    private LuaTable _module;
    private Action _startHandler;
    private Action _updateHandler;

    private void Awake()
    {
        _luaEnv = new LuaEnv();
        _luaEnv.AddLoader(LoadLuaFromScriptsFolder);
        LoadLuaModule();
    }

    private void LoadLuaModule()
    {
        var result = _luaEnv.DoString($"return require '{LuaModuleName}'");
        if (result != null && result.Length > 0)
        {
            _module = result[0] as LuaTable;
        }

        if (_module == null)
        {
            Debug.LogError("[RotateCubeBehaviour] Failed to load RotateCube.lua");
            return;
        }

        _startHandler = _module.Get<Action>("Start");
        _updateHandler = _module.Get<Action>("Update");

        _startHandler?.Invoke();
    }

    private byte[] LoadLuaFromScriptsFolder(ref string relativePath)
    {
        var fullPath = Path.Combine(Application.dataPath, "Scripts", "Lua", relativePath + ".lua");
        if (!File.Exists(fullPath))
        {
            Debug.LogWarning($"[RotateCubeBehaviour] Lua file not found: {fullPath}");
            return null;
        }

        return File.ReadAllBytes(fullPath);
    }

    private void Update()
    {
        _updateHandler?.Invoke();
    }

    private void OnDestroy()
    {
        _updateHandler = null;
        _startHandler = null;

        _module?.Dispose();
        _module = null;

        _luaEnv?.Dispose();
        _luaEnv = null;
    }
}

