using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Star : MonoBehaviour {
    
    public Color starColor = Color.white;
    [Range(1, 20)]
    public float blurSize = 1f;
    [Range(1, 400)]
    public float circleSize = 200f;


    private Shader StarBloom;
    private Material m_material;

    // Use this for initialization
    void OnEnable()
    {
        //StarBloom = ;
        m_material = new Material(Shader.Find("Unlit/Star"));
        //m_material.SetVector("_SunPosition", sunTransform.position);
        gameObject.GetComponent<Renderer>().material = m_material;
        
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 screenCoordinate = Camera.main.WorldToScreenPoint(transform.position);
        
        Vector3 viewportCoordinate = Camera.main.WorldToViewportPoint(transform.position);
        if (viewportCoordinate.x > 0 && viewportCoordinate.x < 1.1 && viewportCoordinate.y > -0.1 && viewportCoordinate.y < 1.0 && viewportCoordinate.z > -0.1)
        {
            screenCoordinate = new Vector3(screenCoordinate.x, Screen.height - screenCoordinate.y, screenCoordinate.z);
            m_material.SetVector("_SunPosition", transform.position);
        }
        else
        {
            screenCoordinate = new Vector3(-1, -1, -1);
            m_material.SetVector("_SunPosition", transform.position);
        }
        m_material.SetFloat("_Size", blurSize);
        m_material.SetFloat("_CircleBlurSize", circleSize);
        m_material.SetVector("_StarColor", starColor);
    }

    
}
