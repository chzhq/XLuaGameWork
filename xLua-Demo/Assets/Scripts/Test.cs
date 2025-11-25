using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Test : MonoBehaviour
{
    Button button;
    void Start()
    {
        button.onClick.AddListener(OnClick);
        gameObject.SetActive(false);
        GameObject.Find("dd");
        transform.GetChild(0).gameObject.SetActive(false);
        Image image = GetComponent<Image>();
        image.sprite = Resources.Load<Sprite>("Sprites/1");
        //transform.childCount
        //transform.GetChild();
        //Ëæ»úÊý
        int a = UnityEngine.Random.Range(0, 10);
        GameObject.Instantiate<GameObject>(Resources.Load<GameObject>("Prefabs/1"));
        GameObject.DestroyImmediate(image);
    }

    private void OnClick()
    {
        throw new NotImplementedException();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
