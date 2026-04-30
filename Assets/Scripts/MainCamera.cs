using System.Collections;
using System.Collections.Generic;
using Cinemachine;
using UnityEngine;

public class MainCamera : MonoBehaviour
{
    public static MainCamera Instance;

    public CinemachineImpulseSource impulseSource;
    // Start is called before the first frame update
    void Awake()
    {
        Instance = this;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void CameraShake()
    {
        impulseSource.GenerateImpulseWithForce(1);
    }
}
