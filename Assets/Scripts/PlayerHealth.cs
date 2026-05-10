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
        base.OnTakeDamage(attackSo, attacker);
        animator.Play("Hit", 1 ,0);
    }
}
