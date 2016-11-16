using UnityEngine;
using System.Collections;

public class BlurEffect : MonoBehaviour {

    public Material shaderEffect;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        //mat is the material containing your shader
        Graphics.Blit(source, destination, shaderEffect);
    }
}
