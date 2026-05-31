using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance;
    public bool cursorEnable;
    public bool gameOver;
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

    public void RestartGame()
    {
        if(gameOver)
        {   
            print("Game Over");
            StartCoroutine(WaitForRestart());

        IEnumerator WaitForRestart()
        {
            yield return new WaitForSeconds(5);
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
            
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
