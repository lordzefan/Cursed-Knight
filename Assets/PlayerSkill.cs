using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSkill : MonoBehaviour
{
    public ParticleSystem swordSlashVfx;
    public GameObject swordChargerVfx;
    Animator animator;

    void Awake()
    {
        animator =  GetComponent<Animator>();
    }
    

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
        {
            animator.CrossFade("Skill Attack", 0.1f);
        }
    }

    public void EnebleChargerVfx() => swordChargerVfx.SetActive(true);
    public void DisbleChargerVfx() => swordChargerVfx.SetActive(false);
    public void PlaySwordSlashVfx() => swordSlashVfx.Play();
    
}
