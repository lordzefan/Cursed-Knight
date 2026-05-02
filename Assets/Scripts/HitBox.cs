using System.Collections;
using System.Collections.Generic;
using System.Linq;
using Cinemachine;
using UnityEngine;

public class HitBox : MonoBehaviour
{
  public string[] targetTags;

  public AttackSo attackSo;
    void OnTriggerEnter(Collider other)
    {
        if(targetTags.Contains(other.tag))
        {
          var targetHealth = other.GetComponent<BaseHealth>();
          if(targetHealth)
          {
            if(targetHealth.isDead) return;
            targetHealth.OnTakeDamage( attackSo);
            print($"hit touch {other.name}"); 
          }
        }
    }
}
