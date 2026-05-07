using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class EnemyHealth : BaseHealth
{
    public Image hpBar;
    
    Animator animator;

    protected override void Awake()
    {
        base.Awake();
        onChangeHealth.AddListener(UpdateHpBar);
        animator = GetComponent<Animator>();
    }

    public override void OnTakeDamage(AttackSo attackSo)
    {
        base.OnTakeDamage(attackSo);
        animator.Play("Hit", 1,0);
    }

    public void UpdateHpBar( float curHealth, float maxHealth)
    {
        hpBar.fillAmount = curHealth / maxHealth;
    }
}
