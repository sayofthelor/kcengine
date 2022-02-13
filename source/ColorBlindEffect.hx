package;

import lime.graphics.Image;
import lime.utils.Assets;
import flixel.system.FlxAssets.FlxShader;

enum abstract ColorBlindnessType(Int) from Int to Int {
    var NONE:Int = 0;
    var PROTONOPIA:Int = 1;
    var DEUTERANOPIA:Int = 2;
    var TRITANOPIA:Int = 3;
}

class ColorBlindEffect {

    public var colorBlindnessType(default, set):Int;

    public var shader:ColorBlindShader;

    public function new(colorBlindnessType:Int) {

        shader = new ColorBlindShader(colorBlindnessType);

        this.colorBlindnessType = colorBlindnessType;
		setColorBlindness(colorBlindnessType);
	}

    function setColorBlindness(colorBlindnessType:Int) {
            return shader.blindnessType.value[0] = colorBlindnessType;
    }

	function set_colorBlindnessType(value:Int):Int {
        colorBlindnessType = value;
        return setColorBlindness(colorBlindnessType);
	}
}

class ColorBlindShader extends FlxShader {

	
	
    // copypasta from: http://blog.noblemaster.com/wp-content/uploads/2013/10/2013-10-26-ColorCorrection.txt


	// OpenGL code for color correction
	// Correction for color blindness (more here: http://tylerdavidhoward.com/thesis/)


	// * dunno how 2 do achromatopsia

    @:glFragmentSource('

#pragma header

const mat3 RGBtoOpponentMat = mat3(0.2814, -0.0971, -0.0930, 0.6938, 0.1458,-0.2529, 0.0638, -0.0250, 0.4665);
const mat3 OpponentToRGBMat = mat3(1.1677, 0.9014, 0.7214, -6.4315, 2.5970, 0.1257, -0.5044, 0.0159, 2.0517);

const int NONE = 0;
const int PROTANOPIA = 1;
const int DEUTERANOPIA = 2;
const int TRITANOPIA = 3;

uniform int blindnessType;

void blindnessFilter( out vec4 myoutput, in vec4 myinput )
{
	if (blindnessType == PROTANOPIA) {
			vec3 opponentColor = RGBtoOpponentMat * vec3(myinput.r, myinput.g, myinput.b);
			opponentColor.x -= opponentColor.y * 1.5; // reds (y <= 0) become lighter, greens (y >= 0) become darker
			vec3 rgbColor = OpponentToRGBMat * opponentColor;
			myoutput = vec4(rgbColor.r, rgbColor.g, rgbColor.b, myinput.a);
	} else if (blindnessType == DEUTERANOPIA) {
			vec3 opponentColor = RGBtoOpponentMat * vec3(myinput.r, myinput.g, myinput.b);
			opponentColor.x -= opponentColor.y * 1.5; // reds (y <= 0) become lighter, greens (y >= 0) become darker
			vec3 rgbColor = OpponentToRGBMat * opponentColor;
			myoutput = vec4(rgbColor.r, rgbColor.g, rgbColor.b, myinput.a);
	} else if (blindnessType == TRITANOPIA) {
			vec3 opponentColor = RGBtoOpponentMat * vec3(myinput.r, myinput.g, myinput.b);
			opponentColor.x -= ((3.0 * opponentColor.z) - opponentColor.y) * 0.25;
			vec3 rgbColor = OpponentToRGBMat * opponentColor;
			myoutput = vec4(rgbColor.r, rgbColor.g, rgbColor.b, myinput.a);
    } else {
			myoutput = myinput;
	}	
}

void blindnessVision( out vec4 myoutput, in vec4 myinput )
{
	vec4 blindVisionR;
	vec4 blindVisionG;
	vec4 blindVisionB;
	if (blindnessType == PROTANOPIA) {
			blindVisionR = vec4( 0.20,  0.99, -0.19, 0.0);
			blindVisionG = vec4( 0.16,  0.79,  0.04, 0.0);
			blindVisionB = vec4( 0.01, -0.01,  1.00, 0.0);
	} else if (blindnessType == DEUTERANOPIA) {
			blindVisionR = vec4( 0.43,  0.72, -0.15, 0.0 );
			blindVisionG = vec4( 0.34,  0.57,  0.09, 0.0 );
			blindVisionB = vec4(-0.02,  0.03,  1.00, 0.0 );		
	} else if (blindnessType == TRITANOPIA) {
			blindVisionR = vec4( 0.97,  0.11, -0.08, 0.0 );
			blindVisionG = vec4( 0.02,  0.82,  0.16, 0.0 );
			blindVisionB = vec4(-0.06,  0.88,  0.18, 0.0 );
	} else {
        	blindVisionR = vec4(1.0,  0.0,  0.0, 0.0 );
        	blindVisionG = vec4(0.0,  1.0,  0.0, 0.0 );
        	blindVisionB = vec4(0.0,  0.0,  1.0, 0.0 );			
	}
	myoutput = vec4(dot(myinput, blindVisionR), dot(myinput, blindVisionG), dot(myinput, blindVisionB), myinput.a);	
}


void main()
{
    vec2 xy = openfl_TextureCoordv; // Condensing this into one line
    vec4 texColor = texture2D(bitmap,xy); // Get the pixel at xy from iChannel0
    vec4 tmp;
    blindnessFilter(tmp, texColor);    
    blindnessVision(gl_FragColor, tmp);
}
    ')


    public function new(colorBlindnessType:Int) {
        super();
        blindnessType.value = [colorBlindnessType];
    }
}