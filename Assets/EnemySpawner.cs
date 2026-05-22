using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpawner : MonoBehaviour
{
    public EnemyController enemyPrefebs;
    public Transform spawnArea;
    public Transform parentMovespotEnemy;

    

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            SpawnEnemy();
        }
        
    }

    void SpawnEnemy()
    {
        var randomRotation = Quaternion.Euler(0, Random.Range(0 , 360), 0);
        var enemy = Instantiate(enemyPrefebs, GetRandomPosition(), randomRotation);
        enemy.Init(parentMovespotEnemy);
    }

    Vector3 GetRandomPosition()
    {
        return spawnArea.position + new Vector3(
            Random.Range(-0.5f, 0.5f) * spawnArea.localScale.x, 
             Random.Range(-0.5f, 0.5f) * spawnArea.localScale.y,
              Random.Range(-0.5f, 0.5f) * spawnArea.localScale.z
        ); 
    }
}
