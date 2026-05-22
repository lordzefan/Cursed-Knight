using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAttack : BaseAttack
{
    EnemyHealth enemyHealth;

    protected override void Awake()
    {
        base.Awake();
        enemyHealth = GetComponent<EnemyHealth>();
    }

    public override void DoAttack()
    {
        if(enemyHealth.isDead) return;
        animator.Play("Attack");
        print("melakukan attack");
    }

}
