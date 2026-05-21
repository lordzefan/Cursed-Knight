using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerHealth : BaseHealth
{
    Animator animator;
    protected override void Awake()
    {
        base.Awake();
        animator = GetComponent<Animator>();
    }
    public override void OnTakeDamage(AttackSo attackSo, BaseAttack attacker)
    {
        if(isDead) return;
        base.OnTakeDamage(attackSo, attacker);
        if (curHealth <= 0)
        {
            OnDead();
        }else
        {
            animator.Play("Hit", 1 ,0);
        }
    }

    public override void OnDead()
    {
        if(isDead) return;
        base.OnDead();
        GameManager.Instance.gameOver = true;
        animator.CrossFade("Dead", 0.1f);
    }
}
