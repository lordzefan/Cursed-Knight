using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseHealth : MonoBehaviour
{
    public float curHealth, maxHealth;
    public bool isDead;
    public ParticleSystem bloodVfx;
    public AudioClip hitSfx;
    AudioSource audioSource;

    void Awake()
    {
        audioSource = GetComponent<AudioSource>();
    }
    void Start()
    {
        curHealth =maxHealth;
    }

    public void OnTakeDamage( AttackSo attackSo)
    {
        var dmgFinal = Random.Range(attackSo.dmgValue.x, attackSo.dmgValue.y);
        if(isDead) return;
        curHealth -= dmgFinal;
        MainCamera.Instance.CameraShake(attackSo.cameraShakePresetSo);
        audioSource.PlayOneShot(hitSfx);
        bloodVfx.Play();
        if(curHealth == 0)OnDead();
        print("on take damage "+ dmgFinal);
    }

    public void OnDead()
    {
       isDead = true; 
       print("enemy is dead");
    }
}
