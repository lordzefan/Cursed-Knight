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

    public void OnTakeDamage(float dmgValue)
    {
        if(isDead) return;
        curHealth -= dmgValue;
        MainCamera.Instance.CameraShake();
        audioSource.PlayOneShot(hitSfx);
        bloodVfx.Play();
        if(curHealth == 0)OnDead();
        print("on take damage");
    }

    public void OnDead()
    {
       isDead = true; 
       print("enemy is dead");
    }
}
