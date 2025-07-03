@tool
class_name RidgedNoiseGenerator
extends NoiseGenerator
## This class generates ridged noise.

## Evaluates the noise at a given position.
func evaluate(v: Vector3) -> float:
	var elevation: float = 1.0 - abs(_simplex.get_noise_3dv(center + v))
	return elevation * elevation * strength
