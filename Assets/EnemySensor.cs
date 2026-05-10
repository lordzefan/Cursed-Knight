using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySensor : MonoBehaviour
{
    EnemyController enemyController;

    void Awake()
    {
        enemyController = GetComponentInParent<EnemyController>();
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            enemyController.ChangeToAttack();
        }        
    }
}
