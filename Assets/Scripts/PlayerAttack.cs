using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : BaseAttack
{
    void Update()
    {
        if(Input.GetMouseButtonDown(0))DoAttack();
    }
    public override void DoAttack()
    {
        base.DoAttack();
    }
}
