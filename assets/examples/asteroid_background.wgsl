#import bevy_pbr::mesh_view_bindings
#import bevy_pbr::utils
#import noisy_bevy::prelude
// #import bevy_pbr::mesh_functions
#import bevy_sprite::mesh2d_bindings

struct AsteroidMaterial {
    params: vec4<f32>
}

@group(1) @binding(0)
var<uniform> material: AsteroidMaterial;

@fragment
fn fragment(
    @builtin(position) position: vec4<f32>,
    #import bevy_sprite::mesh2d_vertex_output
) -> @location(0) vec4<f32> {
    // perf: better to do in vertex shader!
    let p = world_position.xy - vec2(mesh.model[3].x, mesh.model[3].y); // ignoring rotation
    // sample noise
    let p = p.xy;
    let params = material.params;
    let freq_scale = params.x;
    let amp_scale = params.y;
    let radius = params.z;

    let r = sqrt(p.x * p.x + p.y * p.y);
    let d = r - radius;

    let n = simplex_noise_2d(p * freq_scale) * amp_scale;

    let v = d - n;
    let v = pow(-v * 0.1 + 0.3, 2.1);

    return vec4(v, v, v, 1.);
}