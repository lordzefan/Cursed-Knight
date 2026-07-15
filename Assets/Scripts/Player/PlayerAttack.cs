using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : BaseAttack
{
    PlayerHealth playerHealth;
    PlayerBlok playerBlok;

    void Start()
    {
        playerBlok = GetComponent<PlayerBlok>();
    playerHealth = GetComponent<PlayerHealth>();
    }

    void Update()
    {
        if(playerBlok.isBlocking) return;
        if(playerHealth.isDead) return;
        if(Input.GetMouseButtonDown(0))DoAttack();
    }
    public override void DoAttack()
    {
        base.DoAttack();
    }
}
