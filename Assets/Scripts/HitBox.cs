using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Cinemachine;
using UnityEngine;

public class HitBox : MonoBehaviour
{
  public float dmgValue;
  public string[] targetTags;

  public CameraShakePresetSo cameraShakePresetSo;
    void OnTriggerEnter(Collider other)
    {
        if(targetTags.Contains(other.tag))
        {
          var targetHealth = other.GetComponent<BaseHealth>();
          if(targetHealth)
          {
            if(targetHealth.isDead) return;
            targetHealth.OnTakeDamage(dmgValue, cameraShakePresetSo);
            print($"hit touch {other.name}"); 
          }
        }
    }
}
