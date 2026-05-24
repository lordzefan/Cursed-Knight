using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using UnityEngine;

public class EnemyHealth : BaseHealth
{
    public Image hpBar;
    public GameObject enemyCanvas;
    
    Animator animator;
    
    EnemyController enemyController;

    protected override void Awake()
    {
        base.Awake();
        onChangeHealth.AddListener(UpdateHpBar);
        animator = GetComponent<Animator>();
        enemyController = GetComponent<EnemyController>();
    }

    protected override void Start()
    {
        base.Start();
        EnableEnemyCanva(false);
    }

    public void EnableEnemyCanva(bool enable)
    {
        enemyCanvas.SetActive(enable);
    }

    public override void OnTakeDamage(AttackSo attackSo, BaseAttack attacker)
    {
        base.OnTakeDamage(attackSo, attacker);
        if (curHealth <= 0)
        {
            OnDead();
        }else
        {
        animator.Play("Hit", 1,0);
        }
    }

    public override void OnDead()
    {
        if(isDead) return;

        base.OnDead();
        EnableEnemyCanva(false);
        animator.CrossFade("Dead", 0.1f);
        enemyController.OnEnemyDead();
        StartCoroutine(OnDeadCor());
        IEnumerator OnDeadCor()
        {
            yield return new WaitForSeconds(5);
            Destroy(gameObject);
        }
    }

    public void UpdateHpBar( float curHealth, float maxHealth)
    {
        hpBar.fillAmount = curHealth / maxHealth;
    }
}
