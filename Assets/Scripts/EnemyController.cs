using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public enum AiState
{
    IDLE,
    WANDERING,
    ATTACKING
}
public class EnemyController : MonoBehaviour
{
    public AiState aiState;
    public Transform target;
    NavMeshAgent navMeshAgent;
    Animator  animator;
    public float walkSpeed, runSpeed;

    void Awake()
    {
        animator = GetComponent<Animator>();
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    private void Update()
    {
        animator.SetFloat("Movement", navMeshAgent.velocity.magnitude, 0.1f, Time.deltaTime );
        switch (aiState)
        {
            case AiState.IDLE:
                OnIdle();
                break;
            case AiState.WANDERING:
                OnWandering();
                break;
            case AiState.ATTACKING:
                OnAttack();
                break;
        }
    }

    void OnIdle()
    {
        
    }

    void OnWandering()
    {
        navMeshAgent.speed = walkSpeed;
        navMeshAgent.destination = target.position;
    }

    void OnAttack()
    {
        navMeshAgent.speed = runSpeed;
    }
}
