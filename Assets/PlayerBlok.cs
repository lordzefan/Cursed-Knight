using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerBlok : MonoBehaviour
{
    Animator animator;
    public bool isBlocking, isPerfectParry;
    public float perfectParryDuration, perfectParryLimit;

    void Awake()
    {
        animator = GetComponent<Animator>();
    }
    
    // Update is called once per frame
    void Update()
    {
        PerfectParryHandler();
        if (Input.GetMouseButtonDown(1))
        {
            isPerfectParry = true;
            perfectParryDuration = 0;
            isBlocking = true;
            animator.SetBool("Block", true);
        }

        if (Input.GetMouseButtonUp(1))
        {
            isPerfectParry = false;
            isBlocking = false;
            animator.SetBool("Block", false);
        }
    }

    void PerfectParryHandler()
    {
        if (isPerfectParry)
        {
            perfectParryDuration += Time.deltaTime;
            if(perfectParryDuration >= perfectParryLimit)
            {
                isPerfectParry = false;
            }
        }
    }
}
