using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBlok : MonoBehaviour
{
    Animator animator;
    public bool isBlocking;

    void Awake()
    {
        animator = GetComponent<Animator>();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButtonDown(1))
        {
            isBlocking = true;
            animator.SetBool("Block", true);
        }

        if (Input.GetMouseButtonUp(1))
        {
            isBlocking = false;
            animator.SetBool("Block", false);
        }
    }

    void StartBlocking()
    {
        
    }
}
