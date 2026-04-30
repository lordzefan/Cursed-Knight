using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Cinemachine;
using UnityEngine;

[System.Serializable]
public class CameraShakePreset
{
  public float impactForce = 1f;
  public float impactDuration = 0.5f;
  // public Vector3 impactVelocity ;
  public Vector2 randomX, randomY, randomZ;
  public CinemachineImpulseDefinition.ImpulseShapes impulseShapes;

  public Vector3 GetRandomVelocity()
  {
    return new Vector3(
      Random.Range(randomX.x, randomX.y),
      Random.Range(randomY.x, randomY.y),
      Random.Range(randomZ.x, randomZ.y)
    );
  }
}
public class HitBox : MonoBehaviour
{
  public float dmgValue;
  public string[] targetTags;

  public CameraShakePreset cameraShakePreset;
    void OnTriggerEnter(Collider other)
    {
        if(targetTags.Contains(other.tag))
        {
          var targetHealth = other.GetComponent<BaseHealth>();
          if(targetHealth)
          {
            if(targetHealth.isDead) return;
            targetHealth.OnTakeDamage(dmgValue, cameraShakePreset);
            print($"hit touch {other.name}"); 
          }
        }
    }
}
