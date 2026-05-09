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
    public Transform parentTargetMovement;

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
        DebugTest();
    }

    void DebugTest()
    {
        if (Input.GetKeyDown(KeyCode.V))
        {
            ChangeToWandering();
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

    void ChangeToWandering()
    {
        target = GetTargetMovement();
    }

    public Transform GetTargetMovement()
    {
        return parentTargetMovement.GetChild(Random.Range(0, parentTargetMovement.childCount));
    }

    void OnAttack()
    {
        navMeshAgent.speed = runSpeed;
    }
}
