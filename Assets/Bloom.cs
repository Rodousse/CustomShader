using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class Bloom : MonoBehaviour {
    [Range(1, 20)]
    public float blurSize = 1f;

    [Range(0.5f, 1)]
    public float minValue = 0.8f;

    private Shader StarBloom;
    private Material m_material;
    // Use this for initialization
    void Start () {
        m_material = new Material(Shader.Find("Hidden/BloomLowCost"));
	}
	
	// Update is called once per frame
	void Update () {
        m_material.SetFloat("_MinValue", minValue);
        m_material.SetFloat("_Size", blurSize);

    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, m_material);
    }

}
