using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseHealth : MonoBehaviour
{
    public float curHealth, maxHealth;
    public bool isDead;

    void Start()
    {
        curHealth =maxHealth;
    }

    public void OnTakeDamage(float dmgValue)
    {
        if(isDead) return;
        curHealth -= dmgValue;
        if(curHealth == 0)OnDead();
        print("on take damage");
    }

    public void OnDead()
    {
       isDead = true; 
       print("enemy is dead");
    }
}
