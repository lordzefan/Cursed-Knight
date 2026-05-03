using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyHealth : BaseHealth
{
    Animator animator;

    protected override void Awake()
    {
        base.Awake();
        animator = GetComponent<Animator>();
    }

    public override void OnTakeDamage(AttackSo attackSo)
    {
        base.OnTakeDamage(attackSo);
        animator.Play("Hit", 1,0);
    }
}
