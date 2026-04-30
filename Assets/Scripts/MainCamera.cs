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

    public void CameraShake( CameraShakePresetSo cameraShakePresetSo)
    {
        var impulseDefinition = impulseSource.m_ImpulseDefinition;
        impulseDefinition.m_ImpulseDuration = cameraShakePresetSo.impactDuration;
        impulseDefinition.m_ImpulseShape = cameraShakePresetSo.impulseShapes;
        impulseSource.m_DefaultVelocity = cameraShakePresetSo.GetRandomVelocityMinMax();
        impulseSource.GenerateImpulseWithForce(cameraShakePresetSo.impactForce);
    }
}
