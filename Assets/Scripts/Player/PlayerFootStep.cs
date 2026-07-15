using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerFootStep : MonoBehaviour
{

    [SerializeField]
    AudioClip[] footStepClips;
    AudioSource footStep;
    // Start is called before the first frame update
    void Awake()
    {
        footStep = GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PlayFootStepSFX(AnimationEvent animationEvent)
    {
        if(animationEvent.animatorClipInfo.weight > 0.5)
        {
        footStep.PlayOneShot(footStepClips[Random.Range(0, footStepClips.Length)], 0.2f);
        }
    }
}
