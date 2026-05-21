using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CanvasPlayerHpBar : MonoBehaviour
{
    public Slider playerHpBarImage;

    public void UpdateHpBar(float currentHealth, float maxHealth)
    {
        playerHpBarImage.maxValue = maxHealth;
        playerHpBarImage.minValue = 0;

        playerHpBarImage.value = currentHealth;
    }
}
