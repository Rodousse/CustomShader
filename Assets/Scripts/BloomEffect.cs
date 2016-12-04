using UnityEngine;
using System.Collections;

public class BloomEffect : MonoBehaviour {
    public Transform sunTransform;
    private Shader StarBloom;
    private Material m_material;
	// Use this for initialization
	void OnEnable () {
        //StarBloom = ;
        m_material = new Material(Shader.Find("Hidden/StarBloom"));
        m_material.SetVector("_SunPosition", sunTransform.position);
    }
	
	// Update is called once per frame
	

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, m_material);
    }
}
