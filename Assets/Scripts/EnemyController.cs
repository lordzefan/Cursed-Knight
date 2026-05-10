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

    public float idleDuration;
    float  idleDurationNeed;
    public Vector2 randomIdleDuration;

    public float attackRange, attackCooldownDuration, attackCooldownDurationNeed;
    public Vector2 randomAttactCooldownDuration;
    public float distanceToStopAttack;
    public float distanceToTarget;

    void Awake()
    {
        animator = GetComponent<Animator>();
        navMeshAgent = GetComponent<NavMeshAgent>();
    }

    void Start()
    {
        idleDurationNeed = Random.Range(randomIdleDuration.x, randomIdleDuration.y);
        attackCooldownDurationNeed = Random.Range(randomAttactCooldownDuration.x, randomAttactCooldownDuration.y);
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
        navMeshAgent.speed = 0;
        idleDuration = 0;
        idleDurationNeed = Random.Range(randomIdleDuration.x, randomIdleDuration.y);
        aiState = AiState.IDLE;
    }

    void OnWandering()
    {
        navMeshAgent.speed = walkSpeed;
        navMeshAgent.destination = target.position;
        distanceToTarget = Vector3.Distance(transform.position, target.position);

        if (distanceToTarget < 2)
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
        attackCooldownDuration += Time.deltaTime;
        navMeshAgent.destination = target.position;
        distanceToTarget = Vector3.Distance(transform.position, target.position);

        if (distanceToTarget < attackRange )
        {
            navMeshAgent.speed = 0;
            if (attackCooldownDuration >= attackCooldownDurationNeed)
            {
                 animator.CrossFade("Attack", 0.1f);
                 attackCooldownDurationNeed = Random.Range(randomAttactCooldownDuration.x, randomAttactCooldownDuration.y);
                 attackCooldownDuration = 0;
            }
           
        }else
        {
            navMeshAgent.speed = runSpeed;
        }
        
        if (distanceToTarget > distanceToStopAttack)
        {
            ChangeToIdle();
        }

        
    }

    public void ChangeToAttack()
    {
        target = PlayerManager.Instance.transform;
        aiState = AiState.ATTACKING;
    }
}
