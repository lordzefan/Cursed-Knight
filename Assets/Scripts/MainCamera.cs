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

    public void CameraShake( CameraShakePreset cameraShakePreset)
    {
        var impulseDefinition = impulseSource.m_ImpulseDefinition;
        impulseDefinition.m_ImpulseDuration = cameraShakePreset.impactDuration;
        impulseDefinition.m_ImpulseShape = cameraShakePreset.impulseShapes;
        impulseSource.m_DefaultVelocity = cameraShakePreset.GetRandomVelocity();
        impulseSource.GenerateImpulseWithForce(cameraShakePreset.impactForce);
    }
}
