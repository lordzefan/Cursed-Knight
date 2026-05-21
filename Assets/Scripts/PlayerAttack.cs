using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : BaseAttack
{
    PlayerHealth playerHealth;

    void Start()
    {
    playerHealth = GetComponent<PlayerHealth>();
    }

    void Update()
    {
        if(playerHealth.isDead) return;
        if(Input.GetMouseButtonDown(0))DoAttack();
    }
    public override void DoAttack()
    {
        base.DoAttack();
    }
}
