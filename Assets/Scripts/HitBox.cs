using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class HitBox : MonoBehaviour
{
  public float dmgValue;
  public string[] targetTags;
    void OnTriggerEnter(Collider other)
    {
        if(targetTags.Contains(other.tag))
        {
          var targetHealth = other.GetComponent<BaseHealth>();
          if(targetHealth)
          {
            if(targetHealth.isDead) return;
            targetHealth.OnTakeDamage(dmgValue);
            print($"hit touch {other.name}"); 
          }
        }
    }
}
