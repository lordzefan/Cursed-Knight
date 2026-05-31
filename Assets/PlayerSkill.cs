using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerSkill : MonoBehaviour
{
    public ParticleSystem swordSlashVfx;
    public GameObject swordChargerVfx;
    public AudioClip swordSlashSfx;
    public CameraShakePresetSo skillCameraShake;
    public GameObject hitBox;
    AudioSource audioSource;
    Animator animator;
    PlayerHealth playerHealth;
    public Image skillCdImage;

    public float skillCooldownDuration, skillCooldownDurationNeed;
    public bool isSkillCooldown;

    void Awake()
    {
        playerHealth = GetComponent<PlayerHealth>();
        audioSource = GetComponent<AudioSource>();
        animator =  GetComponent<Animator>();
    }
    

    // Update is called once per frame
    void Update()
    {
        if(playerHealth.isDead) return;
        if(isSkillCooldown) 
        {
            skillCooldownDuration += Time.deltaTime;
            skillCdImage.fillAmount = skillCooldownDuration/ skillCooldownDurationNeed;
            if (skillCooldownDuration >= skillCooldownDurationNeed)
            {
                isSkillCooldown = false;
            }
            return;
        }
        if (Input.GetKeyDown(KeyCode.Space))
        {
            animator.CrossFade("Skill Attack", 0.1f);
            skillCooldownDuration =0;
            isSkillCooldown = true;
        }
    }

    public void EnebleChargerVfx() => swordChargerVfx.SetActive(true);
    public void DisbleChargerVfx() => swordChargerVfx.SetActive(false);
    public void EnebleHitBox() => hitBox.SetActive(true);
    public void DisbleHitBox() => hitBox.SetActive(false);
    public void PlaySwordSlashVfx()
    {
        MainCamera.Instance.CameraShake(skillCameraShake);
        swordSlashVfx.Play();
        audioSource.PlayOneShot(swordSlashSfx);
    }
    
}
