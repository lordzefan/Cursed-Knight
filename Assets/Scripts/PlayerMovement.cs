using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    float walkSpeed = 2, runSpeed = 7;
    [SerializeField]
    float rotationSpeed;
    float rotationVelocity;
    public Transform mainCam;
    Rigidbody rb;
    Animator animator;
    PlayerAttack playerAttack;
    PlayerHealth playerHealth;

    void Awake()
    {
        playerHealth = GetComponent<PlayerHealth>();
        playerAttack = GetComponent<PlayerAttack>();
        rb = GetComponent<Rigidbody>();
        animator = GetComponent<Animator>();
    }
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void FixedUpdate()
    {
        if(playerHealth.isDead) return;
       Movement();  
    }

    void Movement()
    {
        float moveX = Input.GetAxisRaw("Horizontal");
        float moveY = Input.GetAxisRaw("Vertical");
        float finalMovementSpeed = Input.GetKey(KeyCode.LeftShift)? runSpeed : walkSpeed;
        
        Vector3 moveDirection = new Vector3(moveX, 0, moveY).normalized;
        animator.SetFloat("Movement", moveDirection.magnitude *finalMovementSpeed, 0.1f, Time.deltaTime);

        if (moveDirection.magnitude >= 0.1f)
        {
            float targetAngle = Mathf.Atan2(moveDirection.x, moveDirection.z)* Mathf.Rad2Deg + mainCam.eulerAngles.y;
        float rotationSmooth = Mathf.SmoothDampAngle(transform.eulerAngles.y,targetAngle, ref rotationVelocity, rotationSpeed);
        transform.rotation = Quaternion.Euler(0, rotationSmooth, 0);

        moveDirection = Quaternion.Euler(0, targetAngle, 0) * Vector3.forward;


        float moveSpeedReduction = 1;
        if(playerAttack.isAttack)
            {
                moveSpeedReduction = 8;                
            }
        rb.MovePosition(rb.position+ moveDirection * finalMovementSpeed/moveSpeedReduction * Time.fixedDeltaTime );
        }
        
    }
}
