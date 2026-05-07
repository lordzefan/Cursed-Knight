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
    AudioSource audioSource;
    public UnityEvent<float, float> onChangeHealth;

    protected virtual void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }
    void Start()
    {
        CurHealth =maxHealth;
    }

    public virtual void OnTakeDamage( AttackSo attackSo)
    {
        var dmgFinal = Random.Range(attackSo.dmgValue.x, attackSo.dmgValue.y);
        if(isDead) return;
        CurHealth -= dmgFinal;
        
        MainCamera.Instance.CameraShake(attackSo.cameraShakePresetSo);
        audioSource.PlayOneShot(hitSfx);
        bloodVfx.Play();
        if(CurHealth == 0)OnDead();
        print("on take damage "+ dmgFinal);
    }

    public void OnDead()
    {
       isDead = true; 
       print("enemy is dead");
    }
}
