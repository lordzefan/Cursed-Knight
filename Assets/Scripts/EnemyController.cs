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
    public float idleDuration, minIdleDuration, maxIdleDuration;
    float  idleDurationNeed;
    public float attackRange;

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
        if (Input.GetKeyDown(KeyCode.B))
        {
            ChangeToAttack();
        }
    }

    void OnIdle()
    {
        idleDuration += Time.deltaTime;

        if (idleDuration > idleDurationNeed)
        {
            ChangeToWandering();
            print("cange to wandering");
        }
        
    }

    void ChangeToIdle()
    {
        idleDuration = 0;
        idleDurationNeed = Random.Range(minIdleDuration, maxIdleDuration);
        aiState = AiState.IDLE;
    }

    void OnWandering()
    {
        navMeshAgent.speed = walkSpeed;
        navMeshAgent.destination = target.position;

        if (Vector3.Distance(transform.position, target.position)< 2)
        {
            ChangeToIdle();
            print("change target");
        }
    }

    void ChangeToWandering()
    {
        target = GetTargetMovement();
        aiState = AiState.WANDERING;
        
    }

    public Transform GetTargetMovement()
    {
        Transform nextTarget;
        do
        {
            nextTarget = parentTargetMovement.GetChild(Random.Range(0, parentTargetMovement.childCount));
        } while (target == nextTarget);

        return nextTarget;
    }

    void OnAttack()
    {
        navMeshAgent.speed = runSpeed;
        navMeshAgent.destination = target.position;

        if (Vector3.Distance(transform.position, target.position)< attackRange )
        {
            animator.CrossFade("Attack", 0.1f);
        }
    }

    void ChangeToAttack()
    {
        target = PlayerManager.Instance.transform;
        aiState = AiState.ATTACKING;
    }
}
