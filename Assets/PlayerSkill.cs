using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerSkill : MonoBehaviour
{
    public ParticleSystem swordSlashVfx;
    public GameObject swordChargerVfx;
    public AudioClip swordSlashSfx;
    public CameraShakePresetSo skillCameraShake;
    public GameObject hitBox;
    AudioSource audioSource;
    Animator animator;

    void Awake()
    {
        audioSource = GetComponent<AudioSource>();
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
    public void EnebleHitBox() => hitBox.SetActive(true);
    public void DisbleHitBox() => hitBox.SetActive(false);
    public void PlaySwordSlashVfx()
    {
        MainCamera.Instance.CameraShake(skillCameraShake);
        swordSlashVfx.Play();
        audioSource.PlayOneShot(swordSlashSfx);
    }
    
}
