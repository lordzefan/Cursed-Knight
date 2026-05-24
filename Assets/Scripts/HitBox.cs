using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class HitBox : MonoBehaviour
{
  public BaseAttack attacker;
  public string[] targetTags;
  public AttackSo attackSo;
  public List<BaseHealth> attackTarget;

    void Awake()
    {
          attacker = GetComponentInParent<BaseAttack>();
    }

    private void OnEnable()
    {
        attackTarget.Clear();
    }

    private void OnDisable()
    {
        attackTarget.Clear();
    }

    void OnTriggerEnter(Collider other)
    {
        if(targetTags.Contains(other.tag))
        {
          var targetHealth = other.GetComponent<BaseHealth>();
          if(attackTarget.Contains(targetHealth)) return; 
          if(targetHealth)
          {
            if(targetHealth.isDead) return;

            attackTarget.Add(targetHealth);
            targetHealth.OnTakeDamage( attackSo, attacker);
            print($"hit touch {other.name}"); 
          }
        }
    }
}
