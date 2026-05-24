using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerHealth : BaseHealth
{
    Animator animator;
    PlayerBlok playerBlok;
    public AudioClip blockHitSfx;
    protected override void Awake()
    {
        base.Awake();
        playerBlok = GetComponent<PlayerBlok>();
        animator = GetComponent<Animator>();
    }
    public override void OnTakeDamage(AttackSo attackSo, BaseAttack attacker)
    {
        if(isDead) return;

        if (playerBlok.isBlocking)
        {
            var dmgFinal = Random.Range(attackSo.dmgValue.x, attackSo.dmgValue.y);
            dmgFinal *= 0.5f;
            CurHealth -= dmgFinal;

            onGettingAttackFromAttacker?.Invoke(attacker);
            audioSource.PlayOneShot(blockHitSfx);
            if (curHealth <= 0)
            {
                OnDead();
            }else
            {
                animator.Play("Block Hit", 1 ,0);
            }
        }else
        {
            base.OnTakeDamage(attackSo, attacker);
            if (curHealth <= 0)
            {
                OnDead();
            }else
            {
                animator.Play("Hit", 1 ,0);
            }
        }
        
        
    }

    public override void OnDead()
    {
        if(isDead) return;
        base.OnDead();
        GameManager.Instance.gameOver = true;
        animator.CrossFade("Dead", 0.1f);
    }
}
