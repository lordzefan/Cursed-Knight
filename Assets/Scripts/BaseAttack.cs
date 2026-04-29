using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseAttack : MonoBehaviour
{

    public HitBox hitBox;
    public bool isAttack;
    Animator animator;

    private void Awake()
    {
        animator = GetComponent<Animator>();
        hitBox.gameObject.SetActive(false);
    }

    public virtual void DoAttack()
    {
        animator.SetTrigger("attack");
    }

    public void OnApplyHitBox()
    {
        hitBox.gameObject.SetActive(true);
    }

    public void OnDisableHitBox()
    {
        hitBox.gameObject.SetActive(false);
    }
}
