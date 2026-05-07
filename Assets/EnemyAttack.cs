using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyAttack : BaseAttack
{
    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            DoAttack();
        }
    }

    public override void DoAttack()
    {
        animator.Play("Attack");
        print("melakukan attack");
    }

}
