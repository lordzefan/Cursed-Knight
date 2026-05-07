using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookOnCam : MonoBehaviour
{
    public Transform mainCam;

    void Start()
    {
        mainCam = MainCamera.Instance.transform;
    }

    void LateUpdate()
    {
        transform.LookAt(mainCam);
    }
}
