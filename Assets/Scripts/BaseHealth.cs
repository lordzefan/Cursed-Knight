using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class BaseHealth : MonoBehaviour
{
    public float curHealth, maxHealth;
    public float CurHealth
    {
        get => curHealth;
        set
        {
            curHealth = value;
            onChangeHealth?.Invoke(curHealth, maxHealth);
        }
    }
    public bool isDead;
    public ParticleSystem bloodVfx;
    public AudioClip hitSfx;
    protected AudioSource audioSource;
    public UnityEvent<float, float> onChangeHealth;
    public UnityEvent<BaseAttack> onGettingAttackFromAttacker;

    protected virtual void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }
    protected virtual void Start()
    {
        CurHealth =maxHealth;
    }

    public virtual void OnTakeDamage( AttackSo attackSo, BaseAttack attacker)
    {
        var dmgFinal = Random.Range(attackSo.dmgValue.x, attackSo.dmgValue.y);
        if(isDead) return;
        CurHealth -= dmgFinal;
        
        MainCamera.Instance.CameraShake(attackSo.cameraShakePresetSo);
        audioSource.PlayOneShot(hitSfx);
        bloodVfx.Play();

        onGettingAttackFromAttacker?.Invoke(attacker);
        if(CurHealth == 0)OnDead();
        print("on take damage "+ dmgFinal);
    }

    public virtual void OnDead()
    {
       isDead = true; 
       print("enemy is dead");
    }
}
