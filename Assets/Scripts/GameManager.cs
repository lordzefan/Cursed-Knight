using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public bool cursorEnable;
    void Awake()
    {
        Instance = this;
    }

    void Start()
    {
        EnableCursor(false);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Tab))
        {
            EnableCursor(!cursorEnable);
        }
    }

    public void EnableCursor(bool enable)
    {
        if (enable)
        {
            cursorEnable = true;
            Cursor.lockState = CursorLockMode.None;
            Cursor.visible = true;
        }else
        {
            cursorEnable = false;
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
    }
}
