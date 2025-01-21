import * as THREE from 'three';
import { MapControls } from 'OrbitControls';
import { Sky } from 'Sky';


let scene, camera, renderer, controls;
let light, color, intensity;
let sky, sun;
let geometry, material, cube;

let geo, mat, mesh;

let raycaster = new THREE.Raycaster();
let pointer = new THREE.Vector2();

let intersects;

let count = 0;

var objects = [];

function init() {
    // Scene
    scene = new THREE.Scene();
    scene.background = new THREE.Color(0xedf1f5);
    scene.fog = new THREE.FogExp2(0xefd1b5, 0.0025);

    // Camera
    camera = new THREE.PerspectiveCamera(75, $("#main").width() / $("#main").height(), 0.1, 1000);
    camera.position.set(0, 16, 0);

    // Renderer
    renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize($("#main").width(), $("#main").height());
    document.getElementById("main").appendChild(renderer.domElement);

    // Controls
    controls = new MapControls(camera, renderer.domElement);
    controls.target.set(0, 0.5, 0);
    controls.update();
    controls.minPolarAngle = THREE.MathUtils.degToRad(0);
    controls.maxPolarAngle = THREE.MathUtils.degToRad(90);
    controls.minDistance = 10;
    controls.maxDistance = 64;
    controls.enablePan = false;

    //const size = 10;
    //const divisions = 10;

    //const gridHelper = new THREE.GridHelper(size, divisions);
    //scene.add(gridHelper);

    // Handle Mouse Inputs
    window.addEventListener('mousedown', function (e) {
        if (intersects.length > 0) {
            intersects[0].object.material.color.set(0xff0000);
        }
    });
    window.addEventListener('pointermove', onPointerMove);

    window.addEventListener('resize', onWindowResize, false);

    initSky();

    lights();

    geo = new THREE.PlaneGeometry(10000, 10000)
    mat = new THREE.MeshLambertMaterial({
        color: "#6e6e6e"
    })
    mesh = new THREE.Mesh(geo, mat)
    mesh.position.set(0, 0, 0)
    mesh.rotation.set(Math.PI / -2, 0, 0)
    scene.add(mesh)

    addNewBoxMesh(0, 2, 0);
    addNewBoxMesh(2, 2, 0);
    addNewBoxMesh(-2, 2, 0);
    addNewBoxMesh(0, 2, -2);
    addNewBoxMesh(2, 2, -2);
    addNewBoxMesh(-2, 2, -2);
    addNewBoxMesh(0, 2, 2);
    addNewBoxMesh(2, 2, 2);
    addNewBoxMesh(-2, 2, 2);
    
    addNewBoxMesh(0, 4, 0);
    addNewBoxMesh(2, 4, 0);
    addNewBoxMesh(-2, 4, 0);
    addNewBoxMesh(0, 4, -2);
    addNewBoxMesh(2, 4, -2);
    addNewBoxMesh(-2, 4, -2);
    addNewBoxMesh(0, 4, 2);
    addNewBoxMesh(2, 4, 2);
    addNewBoxMesh(-2, 4, 2);

    addNewBoxMesh(0, 6, 0);
    addNewBoxMesh(2, 6, 0);
    addNewBoxMesh(-2, 6, 0);
    addNewBoxMesh(0, 6, -2);
    addNewBoxMesh(2, 6, -2);
    addNewBoxMesh(-2, 6, -2);
    addNewBoxMesh(0, 6, 2);
    addNewBoxMesh(2, 6, 2);
    addNewBoxMesh(-2, 6, 2);
}

// Light
function lights() {
    color = 0xFFFFFF;
    intensity = 10;
    light = new THREE.AmbientLight(color, intensity);
    scene.add(light);
}

function initSky() {

    // Add Sky
    sky = new Sky();
    sky.scale.setScalar(450000);
    scene.add(sky);

    sun = new THREE.Vector3();
    
    const effectController = {
        turbidity: 3.5,
        rayleigh: .85,
        mieCoefficient: 0,
        mieDirectionalG: .4,
        elevation: 52,
        azimuth: 180,
        exposure: renderer.toneMappingExposure
    };

    const uniforms = sky.material.uniforms;
    uniforms['turbidity'].value = effectController.turbidity;
    uniforms['rayleigh'].value = effectController.rayleigh;
    uniforms['mieCoefficient'].value = effectController.mieCoefficient;
    uniforms['mieDirectionalG'].value = effectController.mieDirectionalG;

    const phi = THREE.MathUtils.degToRad(90 - effectController.elevation);
    const theta = THREE.MathUtils.degToRad(effectController.azimuth);

    sun.setFromSphericalCoords(1, phi, theta);

    uniforms['sunPosition'].value.copy(sun);

}

function addCube() {
    //geometry = new THREE.BoxGeometry(1, 1, 1);
    ////material = new THREE.MeshBasicMaterial({ color: 0x00ff00 });
    //material = new THREE.MeshPhongMaterial({
    //    color: 0x00ff00,
    //    flatShading: true,
    //});

    var cube = new THREE.Mesh(
        new THREE.BoxGeometry(1, 1, 1),
        [
            new THREE.MeshLambertMaterial({ color: 'black' }),
            new THREE.MeshLambertMaterial({ color: 'blue' }),
            new THREE.MeshLambertMaterial({ color: 'green' }), // top
            new THREE.MeshLambertMaterial({ color: 'red' }),
            new THREE.MeshLambertMaterial({ color: 'orange' }),
            new THREE.MeshLambertMaterial({ color: 'lightgray' }), // north
        ]
    );

    //cube = new THREE.Mesh(geometry, material);
    scene.add(cube);
}

// Handle Resize
function onWindowResize() {
    camera.aspect = $("#main").width() / $("#main").height();
    camera.updateProjectionMatrix();

    renderer.setSize($("#main").width(), $("#main").height());
}

// Raycaster function
function onPointerMove(event) {
    pointer.x = (event.clientX / window.innerWidth) * 2 - 1;
    pointer.y = - (event.clientY / window.innerHeight) * 2 + 1;
    
    raycaster.setFromCamera(pointer, camera);
    intersects = raycaster.intersectObjects(objects, scene.children);

    if (intersects.length > 0) {
        $('html,body').css('cursor', 'pointer');
    }
    else {
        $('html,body').css('cursor', 'default');
    }
}

function addNewBoxMesh(x, y, z) {
    const boxGeometry = new THREE.BoxGeometry(1, 1, 1);
    const boxMaterial = new THREE.MeshPhongMaterial({ color: 0xfafafa });

    const boxMesh = new THREE.Mesh(boxGeometry, boxMaterial);

    boxMesh.position.set(x, y, z)
    boxMesh.name = "test" + count;

    scene.add(boxMesh);
    objects.push(boxMesh);
    count++;
}

function animate() {
    requestAnimationFrame(animate);
    renderer.render(scene, camera);
}

init();
animate();
